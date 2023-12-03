extends Area2D

var door_open = false

@onready var sprite_2d = $Sprite2D


func _ready():
	sprite_2d.modulate = Color(1, 1, 1, 0.3)


func _open_door():
	door_open = true
	sprite_2d.modulate = Color(1, 1, 1, 1)


func _on_body_entered(body):
	if body is Character and door_open:
		Game.go_to_next_level()
