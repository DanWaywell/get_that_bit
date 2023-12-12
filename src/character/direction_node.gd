extends Node2D

@onready var character: Character = $".."


func process() -> void:
	if character.x_input > 0:
		scale.x = Game.RIGHT
		character.direction_facing = Game.RIGHT
	elif character.x_input < 0:
		scale.x = Game.LEFT
		character.direction_facing = Game.LEFT
