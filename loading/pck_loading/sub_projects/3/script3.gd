extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = 80 + 50 * cos(Time.get_ticks_msec()/200.0)
	position.y = 80 + 30 * sin(Time.get_ticks_msec()/250.0)
