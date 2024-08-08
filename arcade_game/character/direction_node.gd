extends Node2D

@onready var character: Character = $".."


func process() -> void:
	if character.x_input > 0:
		character.direction_facing = Vector2.RIGHT
		scale.x = character.direction_facing.x
	elif character.x_input < 0:
		character.direction_facing = Vector2.LEFT
		scale.x = character.direction_facing.x

func flip_direction() -> void:
	scale.x *= -1
	if scale.x == -1:
		character.direction_facing  = Vector2.LEFT
	else:
		character.direction_facing  = Vector2.RIGHT
