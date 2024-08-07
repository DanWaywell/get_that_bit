extends Node2D

@onready var character: Character = $".."


func process() -> void:
	if character.x_input > 0:
		scale.x = Game.RIGHT
		character.direction_facing = Game.RIGHT
	elif character.x_input < 0:
		scale.x = Game.LEFT
		character.direction_facing = Game.LEFT

func flip_direction() -> void:
	scale.x *= -1
	if scale.x == -1:
		character.direction_facing  = Game.LEFT
	else:
		character.direction_facing  = Game.RIGHT
