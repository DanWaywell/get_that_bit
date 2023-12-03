extends Node

const PATH_TITLE_SCREEN = "res://menu/title_screen.tscn"
const PATH_END_SCREEN = "res://menu/end_screen.tscn"

const PATH_FIRST_LEVEL = "res://level/level_1001.tscn"
const FIRST_LEVEL_NUMBER = 1001
const PATH_BEGIN = "res://level/level_"
const PATH_END = ".tscn"

var current_level_number := FIRST_LEVEL_NUMBER
var current_level_address := PATH_FIRST_LEVEL


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


func build_level_path_from_number(level_number):
	var next_level_path = PATH_BEGIN + str(level_number) + PATH_END
	return next_level_path


func change_scene_to(path):
	get_tree().call_deferred("change_scene_to_file", path)


func go_to_title_screen():
	change_scene_to(PATH_TITLE_SCREEN)


func end_game():
	change_scene_to(PATH_END_SCREEN)


func reset_game_data():
	current_level_number = FIRST_LEVEL_NUMBER
	current_level_address =  PATH_FIRST_LEVEL


func reset_game():
	reset_game_data()
	change_scene_to(PATH_TITLE_SCREEN)


func go_to_next_level():
	var number = current_level_number + 1
	var path = build_level_path_from_number(number)
	
	if level_exists(path):
		change_to_level(number)
	else:
		end_game()


func level_exists(path):
	if ResourceLoader.exists(path):
		return true
	else:
		return false


func change_to_level(number):
	var path = build_level_path_from_number(number)
	if level_exists(path):
		current_level_number = number
		current_level_address = path
		change_scene_to(path)
	else:
		assert("Level Does Not Exist!")
