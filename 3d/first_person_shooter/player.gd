class_name Player
extends CharacterBody3D

const MOUSE_SENSITIVITY = 0.0005

## Base speed multiplier.
const SPEED = 1.0

## Jump speed (affects ow high you jump).
const JUMP_VELOCITY = 10.0

## How fast you accelerate while airborne. This influences maximum movement speed too.
const AIR_ACCELERATION_FACTOR = 0.27

## How fast you accelerate while in water. This influences maximum movement speed too.
const WATER_ACCELERATION_FACTOR = 0.55

## How strong gravity is underwater, compared to the default gravity (1.0 is full gravity).
const WATER_GRAVITY_FACTOR = 0.1

## Maximum upwards vertical speed allowed while in water.
const WATER_DAMPING_FLOAT = 5.0

## Maximum downwards vertical speed allowed while in water.
const WATER_DAMPING_SINK = 2.5

## How fast you swim upwards while pressing the Jump key underwater.
const WATER_JUMP_SPEED = 25.0

## How fast the camera recovers from falling (bobbing effect). Higher values result in faster recovery.
const BOB_FALL_RECOVER_SPEED = 9.0

## Number of bullets fired by the weapon.
const SHOTGUN_BULLET_COUNT = 14

# Time counter for view bobbing (doesn't increment while airborne).
var bob_cycle_counter := 0.0
# Fall impact accumulator for camera landing effect.
var bob_fall_counter := 0.0
# Fall impact accumulator for camera landing effect.
var bob_fall_increment := 0.0

# Velocity on the previous physics frame (used to calculate speed changes for landing effects).
var previous_velocity := Vector3.ZERO

# `true` if the player is currently in water, `false` otherwise.
var in_water := false

# The height of the water plane the player is currently in (in global Y coordinates).
# This is used to check whether the camera is underwater to apply effects.
# When not in water, this is set to negative infinity to ensure checks against it are always `false`.
var water_plane_y := -INF

var base_height := ProjectSettings.get_setting("display/window/size/viewport_height")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var initial_camera_position: Vector3 = $Camera3D.position
@onready var initial_underwater_color: Color = $UnderwaterEffect.color


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# V-Sync is disabled to reduce input lag. To avoid excessive power consumption,
	# FPS is capped to (roughly) the refresh rate of the fastest monitor on the system.
	var highest_refresh_rate := 60.0
	for screen in DisplayServer.get_screen_count():
		highest_refresh_rate = max(highest_refresh_rate, DisplayServer.screen_get_refresh_rate(screen))
	Engine.max_fps = int(highest_refresh_rate) + 2

	# Prevent underwater "out" transition from playing on scene load.
	$UnderwaterEffect.color = Color.TRANSPARENT


func _physics_process(delta):
	# Camera effects (view bobbing)

	if abs(previous_velocity.y - velocity.y) >= 8.0:
		# FIXME: This never occurs since the transition to ShapeCast3D for floor detection.
		# We've just landed, apply landing increase.
		print("fall")
		bob_fall_increment += 0.1

	# Increase landing offset over time, but decrease both the landing increment and the offset.
	# This leads to a parabola-like appearance of the landing effect: the effect increases progressively,
	# then decreases progressively.
	bob_fall_counter += bob_fall_increment
	bob_fall_increment = lerpf(bob_fall_increment, 0.0, BOB_FALL_RECOVER_SPEED * delta)

	if $ShapeCast3D.is_colliding():
		# Don't bob camera while airborne.
		bob_cycle_counter += delta

	# Perform view bobbing based on horizontal movement speed, and also apply the fall bobbing offset.
	# We can't use `v_offset` as it would depend on view pitch.
	$Camera3D.position.y = initial_camera_position.y + sin(bob_cycle_counter * 10) * 0.01 * Vector3(velocity.x, 0, velocity.z).length() - bob_fall_counter

	# Perform weapon sprite bobbing (horizontal and vertical), and also apply the fall bobbing offset on the weapon sprite.
	$Camera3D/WeaponSprite.offset.x = cos(bob_cycle_counter * 10) * 0.2 * Vector3(velocity.x, 0, velocity.z).length()
	$Camera3D/WeaponSprite.offset.y = -cos(sin(bob_cycle_counter * 10)) * 0.5 * Vector3(velocity.x, 0, velocity.z).length() - bob_fall_counter * 15

	# Reduce fall bobbing offset over time.
	bob_fall_counter = lerpf(bob_fall_counter, 0.0, BOB_FALL_RECOVER_SPEED * delta)

	# Roll the camera based on sideways movement speed.
	var roll := velocity.dot($Camera3D.transform.basis.x)
	$Camera3D.rotation.z = -roll * 0.003

	# Physics

	# We don't use `is_on_floor()` and rely on the ShapeCast3D's results to determine
	# whether the player is on the floor. This is because we need to use the same check
	# for stair climbing (to avoid discrepancies between both functions).

	# Add the gravity (and perform damping if in water).
	if not $ShapeCast3D.is_colliding():
		if in_water:
			# Lower gravity while in water.
			velocity.y -= WATER_GRAVITY_FACTOR * gravity * delta
			# Perform damping for vertical speed while in water.
			velocity.y = clampf(velocity.y, -WATER_DAMPING_SINK, WATER_DAMPING_FLOAT)
		else:
			velocity.y -= gravity * delta


	# Handle Jump.
	if Input.is_action_pressed("jump") and (in_water or $ShapeCast3D.is_colliding()):
		if in_water:
			# Allow jumping while in water to swim upwards, but more slowly.
			# Here, jumping is performed every frame if underwater, so multiply it by `delta`.
			velocity.y += WATER_JUMP_SPEED * delta
		else:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var motion := Vector3()
	if direction:
		motion.x = direction.x * SPEED
		motion.z = direction.z * SPEED

	motion = motion.rotated(Vector3.UP, $Camera3D.rotation.y)

	if Input.is_action_pressed(&"walk"):
		# Slow down player movement.
		motion *= 0.5

	if in_water:
		motion *= WATER_ACCELERATION_FACTOR

	if not $ShapeCast3D.is_colliding():
		# Slow down player movement (to take reduced friction into account,
		# and give the impression of reduced air control).
		motion *= AIR_ACCELERATION_FACTOR

	velocity += motion

	# `velocity` is reset after calling `move_and_slide()`, so this must be set before calling `move_and_slide()`.
	previous_velocity = velocity

	if not Input.is_action_pressed("jump") and $ShapeCast3D.is_colliding():
		# Stair climbing.
		# FIXME: Prevent camera from snapping downwards after landing from a jump.
		# FIXME: Check collision normal to prevent stepping on steep slopes (> 46 degrees).
		global_position.y = 1.0 + $ShapeCast3D.get_collision_point(0).y

	move_and_slide()

	# Apply friction.
	var friction := 0.94 if $ShapeCast3D.is_colliding() else 0.985
	velocity.x *= friction
	velocity.z *= friction

	# Check if camera is underwater to apply effects.
	if $Camera3D.global_position.y < water_plane_y:
		# Smoothly transition underwater TextureRect overlay.
		$UnderwaterEffect.color = lerp($UnderwaterEffect.color, initial_underwater_color, 12 * delta)
		# Enable low-pass effect on the Master bus.
		# FIXME: Apply on a new SFX bus, so that music is not affected.
		AudioServer.set_bus_effect_enabled(0, 0, true)
	else:
		$UnderwaterEffect.color = lerp($UnderwaterEffect.color, Color.TRANSPARENT, 12 * delta)
		# Disable low-pass effect on the Master bus.
		# FIXME: Apply on a new SFX bus, so that music is not affected.
		AudioServer.set_bus_effect_enabled(0, 0, false)

func _process(_delta):
	# Shooting
	if Input.is_action_pressed("attack") and is_zero_approx($ShootTimer.time_left):
		for i in SHOTGUN_BULLET_COUNT:
			var bullet = preload("res://bullet.tscn").instantiate()
			# Bullets are not child of the player to prevent moving along the player.
			get_parent().add_child(bullet)
			bullet.global_transform = $Camera3D.global_transform
			bullet.rotation.y += -0.1 + randf() * 0.2
			bullet.rotation.x += -0.05 + randf() * 0.1

		$ShootTimer.start()
		$WeaponSounds.play()
		$AnimationPlayer.play("fire")


func _input(event):
	if event is InputEventMouseMotion:
		# Compensate motion speed to be resolution-independent (based on the window height).
		var relative_motion: Vector2 = event.relative * DisplayServer.window_get_size().y / base_height
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x - relative_motion.y * MOUSE_SENSITIVITY, -TAU * 0.25, TAU * 0.25)
		$Camera3D.rotation.y -= relative_motion.x * MOUSE_SENSITIVITY

	if event.is_action_pressed(&"quit"):
		get_tree().quit()

	if event.is_action_pressed(&"toggle_flashlight"):
		$Camera3D/Flashlight.visible = not $Camera3D/Flashlight.visible