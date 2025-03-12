extends Area2D

var door_open := false

@onready var sprite: Sprite2D = $Sprite


func _ready():
	sprite.modulate = Color(1, 1, 1, 0.3)


func _open_door():
	door_open = true
	sprite.modulate = Color(1, 1, 1, 1)


func _on_body_entered(body):
	if body is Character and door_open:
		get_parent().Game.go_to_next_level()
