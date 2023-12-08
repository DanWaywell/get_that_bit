extends Node2D

@onready var audio_jump: AudioStreamPlayer2D = $AudioJump
@onready var audio_explode: AudioStreamPlayer2D = $AudioExplode


func play_jump() -> void:
	audio_jump.play()

func play_explode():
	audio_explode.play()
