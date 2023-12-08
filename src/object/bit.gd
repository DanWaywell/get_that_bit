extends Area2D

var picked_up := false

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var audio_picked_up: AudioStreamPlayer2D = $AudioPickedUp


func _on_body_entered(body):
	if body is Character and not picked_up:
		picked_up = true
		sprite.frame = 1
		collision_shape.set_deferred("disabled", true)
		audio_picked_up.play()


func _on_audio_picked_up_finished() -> void:
	call_deferred("queue_free")
