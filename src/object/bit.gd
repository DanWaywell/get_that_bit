extends Area2D

var picked_up := false

@onready var collision_shape: CollisionShape2D = $CollisionShape


func _on_body_entered(body):
	if body is Character and not picked_up:
		picked_up = true
		collision_shape.set_deferred("disabled", true)
		call_deferred("queue_free")
