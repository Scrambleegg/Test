extends Node2D


func _on_toggle_music_toggled(button_pressed):
	if (button_pressed):
		get_node("SoundEffects/AudioStreamPlayerMusic").play()
	else:
		get_node("SoundEffects/AudioStreamPlayerMusic").stop()
		



func _on_ding_button_pressed():
	get_node("SoundEffects/AudioStreamPlayerDing").play()


func _on_glass_button_pressed():
	get_node("SoundEffects/AudioStreamPlayerGlass").play()


func _on_meow_button_pressed():
	get_node("SoundEffects/AudioStreamPlayerMeow").play()


func _on_beeps_button_pressed():
	get_node("SoundEffects/AudioStreamPlayerBeeps").play()


func _on_trombone_button_pressed():
	get_node("SoundEffects/AudioStreamPlayerTrombone").play()


func _on_static_button_pressed():
	get_node("SoundEffects/AudioStreamPlayerStatic").play()


func _on_whistle_button_pressed():
	get_node("SoundEffects/AudioStreamPlayerWhistle").play()



func _on_toggle_amplify_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,0,true)
	else:
		AudioServer.set_bus_effect_enabled(0,0,false)


func _on_toggle_band_limiter_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,1,true)
	else:
		AudioServer.set_bus_effect_enabled(0,1,false)


func _on_toggle_band_pass_filter_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,2,true)
	else:
		AudioServer.set_bus_effect_enabled(0,2,false)


func _on_toggle_chorus_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,3,true)
	else:
		AudioServer.set_bus_effect_enabled(0,3,false)


func _on_toggle_compressor_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,4,true)
	else:
		AudioServer.set_bus_effect_enabled(0,4,false)


func _on_toggle_delay_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,5,true)
	else:
		AudioServer.set_bus_effect_enabled(0,5,false)



func _on_toggle_distortion_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,6,true)
	else:
		AudioServer.set_bus_effect_enabled(0,6,false)



func _on_toggle_eq_6_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,7,true)
	else:
		AudioServer.set_bus_effect_enabled(0,7,false)


func _on_toggle_eq_10_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,8,true)
	else:
		AudioServer.set_bus_effect_enabled(0,8,false)
		
		


func _on_toggle_eq_21_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,9,true)
	else:
		AudioServer.set_bus_effect_enabled(0,9,false)


func _on_toggle_high_pass_filter_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,10,true)
	else:
		AudioServer.set_bus_effect_enabled(0,10,false)


func _on_toggle_low_shelf_filter_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,11,true)
	else:
		AudioServer.set_bus_effect_enabled(0,11,false)



func _on_toggle_notch_filter_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,12,true)
	else:
		AudioServer.set_bus_effect_enabled(0,12,false)


func _on_toggle_panner_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,13,true)
	else:
		AudioServer.set_bus_effect_enabled(0,13,false)
		


func _on_toggle_phaser_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,14,true)
	else:
		AudioServer.set_bus_effect_enabled(0,14,false)
		


func _on_toggle_pitch_shift_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,15,true)
	else:
		AudioServer.set_bus_effect_enabled(0,15,false)
		


func _on_toggle_reverb_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,16,true)
	else:
		AudioServer.set_bus_effect_enabled(0,16,false)
		


func _on_toggle_stereo_enhance_toggled(button_pressed):
	if(button_pressed):
		AudioServer.set_bus_effect_enabled(0,17,true)
	else:
		AudioServer.set_bus_effect_enabled(0,17,false)





