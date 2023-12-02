extends Node

const title_screen = "res://menu/title_screen.tscn"
const end_screen = "res://menu/end_screen.tscn"

const first_level_adderess = "res://level/level_1001.tscn"
const first_level_number = 1001
const adderess_begining = "res://level/level_"
const adderess_end = ".tscn"

var current_level_number := first_level_number
var current_level_address := first_level_adderess


func _process(delta):
	# Quit
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().current_scene.name != "TitleScreen":
			go_to_title_screen()
		else:
			get_tree().quit()
	# Fullscreen
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1280, 720))
			DisplayServer.window_set_position(Vector2i(320, 180))


func go_to_next_level():
	# build level address
	var next_level_number = current_level_number + 1
	var next_level_adderess = adderess_begining + str(next_level_number) + adderess_end
	
	# check if scene exists and change scene or go to end screen
	if ResourceLoader.exists(next_level_adderess):
		current_level_number = int(next_level_number)
		current_level_address = next_level_adderess
		get_tree().call_deferred("change_scene_to_file", current_level_address)
	else:
		current_level_number = first_level_number
		current_level_address =  first_level_adderess
		get_tree().call_deferred("change_scene_to_file", end_screen)


func go_to_title_screen():
	get_tree().call_deferred("change_scene_to_file", title_screen)
