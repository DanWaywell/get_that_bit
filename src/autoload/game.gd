extends Node

enum {LEFT = -1, RIGHT = 1}

const PATH_TITLE_SCREEN = "res://screen/title_screen.tscn"
const PATH_END_SCREEN = "res://screen/end_screen.tscn"

const FIRST_LEVEL_NUMBER = 1001
const PATH_FIRST_LEVEL = "res://level/level_1001.tscn"
const PATH_BEGIN = "res://level/level_"
const PATH_END = ".tscn"

var level_number: int = FIRST_LEVEL_NUMBER
var level_path : String = PATH_FIRST_LEVEL


func start():
	_change_scene_to(level_path)


func reset_game():
	_reset_data()
	_change_scene_to(PATH_TITLE_SCREEN)


func go_to_next_level():
	var number = level_number + 1
	var path = _build_level_path_from_number(number)
	
	if _level_exists(path):
		_change_to_level(number)
	else:
		_go_to_end_screen()


func reset_level():
	get_tree().call_deferred("reload_current_scene")


func go_to_title_screen():
	_change_scene_to(PATH_TITLE_SCREEN)


func _change_to_level(number: int):
	var path = _build_level_path_from_number(number)
	if _level_exists(path):
		level_number = number
		level_path = path
		_change_scene_to(path)
	else:
		print("Error from Game._change_to_level(). Level doesn't exist")


func _build_level_path_from_number(number: int) -> String:
	var next_level_path = PATH_BEGIN + str(number) + PATH_END
	return next_level_path


func _change_scene_to(path: String):
	get_tree().call_deferred("change_scene_to_file", path)


func _go_to_end_screen():
	_change_scene_to(PATH_END_SCREEN)


func _reset_data():
	level_number = FIRST_LEVEL_NUMBER
	level_path =  PATH_FIRST_LEVEL


func _level_exists(path: String) -> bool:
	if ResourceLoader.exists(path):
		return true
	else:
		return false
