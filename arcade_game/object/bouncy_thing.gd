extends Area2D

@export var bounce_velocity := 100.0

var bounced_list = []

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		body.bounce(bounce_velocity)
		animation_player.play("bounce")
