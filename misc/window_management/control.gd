
extends Control

onready var observer = get_node("../Observer")

# Member variables
var mousepos

func _fixed_process(delta):
	var modetext = "Mode:\n"
	
	if(OS.is_window_fullscreen()):
		modetext += "Fullscreen\n"
	else:
		modetext += "Windowed\n"
	
	if(!OS.is_window_resizable()):
		modetext += "FixedSize\n"
	
	if(OS.is_window_minimized()):
		modetext += "Minimized\n"
	
	if(OS.is_window_maximized()):
		modetext += "Maximized\n"
	
	if(Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		modetext += "MouseGrab\n"
		get_node("Label_MOUSE_MODE_CAPTURED_KeyInfo").show()
	else:
		get_node("Label_MOUSE_MODE_CAPTURED_KeyInfo").hide()
	
	get_node("Label_Mode").set_text(modetext)
	
	get_node("Label_Position").set_text(str("Position:\n", OS.get_window_position()))
	
	get_node("Label_Size").set_text(str("Size:\n", OS.get_window_size()))
	
	get_node("Label_MousePosition").set_text(str("Mouse Position:\n", mousepos))
	
	get_node("Label_Screen_Count").set_text(str("Screen_Count:\n", OS.get_screen_count()))
	
	get_node("Label_Screen_Current").set_text(str("Screen:\n", OS.get_current_screen()))
	
	get_node("Label_Screen0_Resolution").set_text(str("Screen0 Resolution:\n", OS.get_screen_size()))
	
	get_node("Label_Screen0_Position").set_text(str("Screen0 Position:\n", OS.get_screen_position()))

	get_node("Label_Screen0_DPI").set_text(str("Screen0 DPI:\n", OS.get_screen_dpi()))
	
	if(OS.get_screen_count() > 1):
		get_node("Button_Screen0").show()
		get_node("Button_Screen1").show()
		get_node("Label_Screen1_Resolution").show()
		get_node("Label_Screen1_Position").show()
		get_node("Label_Screen1_DPI").show()
		get_node("Label_Screen1_Resolution").set_text(str("Screen1 Resolution:\n", OS.get_screen_size(1)))
		get_node("Label_Screen1_Position").set_text(str("Screen1 Position:\n", OS.get_screen_position(1)))
		get_node("Label_Screen1_DPI").set_text(str("Screen1 DPI:\n", OS.get_screen_dpi(1)))
	else:
		get_node("Button_Screen0").hide()
		get_node("Button_Screen1").hide()
		get_node("Label_Screen1_Resolution").hide()
		get_node("Label_Screen1_Position").hide()
		get_node("Label_Screen1_DPI").hide()
	
	get_node("Button_Fullscreen").set_pressed(OS.is_window_fullscreen())
	get_node("Button_FixedSize").set_pressed(!OS.is_window_resizable())
	get_node("Button_Minimized").set_pressed(OS.is_window_minimized())
	get_node("Button_Maximized").set_pressed(OS.is_window_maximized())
	get_node("Button_MOUSE_MODE_VISIBLE").set_pressed(Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE)
	get_node("Button_MOUSE_MODE_HIDDEN").set_pressed(Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN)
	get_node("Button_MOUSE_MODE_CAPTURED").set_pressed(Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)


func check_wm_api():
	var s = ""
	if(!OS.has_method("get_screen_count")):
		s += " - get_screen_count()\n"
	
	if(!OS.has_method("get_current_screen")):
		s += " - get_current_screen()\n"
	
	if(!OS.has_method("set_current_screen")):
		s += " - set_current_screen()\n"
	
	if(!OS.has_method("get_screen_position")):
		s += " - get_screen_position()\n"
	
	if(!OS.has_method("get_screen_size")):
		s += " - get_screen_size()\n"
	
	if(!OS.has_method("get_window_position")):
		s += " - get_window_position()\n"
	
	if(!OS.has_method("set_window_position")):
		s += " - set_window_position()\n"
	
	if(!OS.has_method("get_window_size")):
		s += " - get_window_size()\n"
	
	if(!OS.has_method("set_window_size")):
		s += " - set_window_size()\n"
	
	if(!OS.has_method("set_window_fullscreen")):
		s += " - set_window_fullscreen()\n"
	
	if(!OS.has_method("is_window_fullscreen")):
		s += " - is_window_fullscreen()\n"
	
	if(!OS.has_method("set_window_resizable")):
		s += " - set_window_resizable()\n"
	
	if(!OS.has_method("is_window_resizable")):
		s += " - is_window_resizable()\n"
	
	if(!OS.has_method("set_window_minimized")):
		s += " - set_window_minimized()\n"
	
	if(!OS.has_method("is_window_minimized")):
		s += " - is_window_minimized()\n"
	
	if(!OS.has_method("set_window_maximized")):
		s += " - set_window_maximized()\n"
	
	if(!OS.has_method("is_window_maximized")):
		s += " - is_window_maximized()\n"
	
	if(s.length() == 0):
		return true
	else:
		var text = get_node("ImplementationDialog/Text").get_text()
		get_node("ImplementationDialog/Text").set_text(text + s)
		get_node("ImplementationDialog").show()
		return false


func _ready():
	if(check_wm_api()):
		set_fixed_process(true)
		set_process_input(true)


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		mousepos = event.pos
	
	if (event.type == InputEvent.KEY):
		if Input.is_action_pressed("F1_MOUSE_MODE_VISIBLE"):
			observer.state = observer.STATE_MENU
			_on_Button_MOUSE_MODE_VISIBLE_pressed()
		
		if Input.is_action_pressed("F2_MOUSE_MODE_HIDDEN"):
			observer.state = observer.STATE_MENU
			_on_Button_MOUSE_MODE_HIDDEN_pressed()
		
		if Input.is_action_pressed("F3_MOUSE_MODE_CAPTURED"):
			_on_Button_MOUSE_MODE_CAPTURED_pressed()


func _on_Button_MoveTo_pressed():
	OS.set_window_position(Vector2(100, 100))


func _on_Button_Resize_pressed():
	OS.set_window_size(Vector2(1024, 768))


func _on_Button_Screen0_pressed():
	OS.set_current_screen(0)


func _on_Button_Screen1_pressed():
	OS.set_current_screen(1)


func _on_Button_Fullscreen_pressed():
	if(OS.is_window_fullscreen()):
		OS.set_window_fullscreen(false)
	else:
		OS.set_window_fullscreen(true)


func _on_Button_FixedSize_pressed():
	if(OS.is_window_resizable()):
		OS.set_window_resizable(false)
	else:
		OS.set_window_resizable(true)


func _on_Button_Minimized_pressed():
	if(OS.is_window_minimized()):
		OS.set_window_minimized(false)
	else:
		OS.set_window_minimized(true)


func _on_Button_Maximized_pressed():
	if(OS.is_window_maximized()):
		OS.set_window_maximized(false)
	else:
		OS.set_window_maximized(true)


func _on_Button_MOUSE_MODE_VISIBLE_pressed():
	Input.set_mouse_mode( Input.MOUSE_MODE_VISIBLE )


func _on_Button_MOUSE_MODE_HIDDEN_pressed():
	Input.set_mouse_mode( Input.MOUSE_MODE_HIDDEN )


func _on_Button_MOUSE_MODE_CAPTURED_pressed():
	observer.state = observer.STATE_GRAB






