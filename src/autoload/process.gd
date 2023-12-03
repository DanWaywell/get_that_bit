extends Node

@onready var game = $".."

func _process(_delta):
	# Quit
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().current_scene.name == "TitleScreen":
			get_tree().quit()
		else:
			game._go_to_title_screen()
	
	# Fullscreen
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1280, 720))
			DisplayServer.window_set_position(Vector2i(320, 180))
