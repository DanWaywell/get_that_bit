extends Node3D

@export var direction_button_up := ""
@export var direction_button_down := ""
@export var direction_button_left := ""
@export var direction_button_right := ""

func _process(_delta: float) -> void:
	if direction_button_up == "" or direction_button_down == "":
		pass
	else:
		if Input.is_action_pressed(direction_button_up) and not Input.is_action_pressed(direction_button_down):
			$Stick.rotation_degrees.x = -14
		elif Input.is_action_pressed(direction_button_down) and not Input.is_action_pressed(direction_button_up):
			$Stick.rotation_degrees.x = 14
		else:
			$Stick.rotation_degrees.x = 0
	
	if direction_button_left == "" or direction_button_right == "":
		pass
	else:
		if Input.is_action_pressed(direction_button_left) and not Input.is_action_pressed(direction_button_right):
			$Stick.rotation_degrees.z = 14
		elif Input.is_action_pressed(direction_button_right) and not Input.is_action_pressed(direction_button_left):
			$Stick.rotation_degrees.z = -14
		else:
			$Stick.rotation_degrees.z = 0
