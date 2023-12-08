extends Node2D

var audio_jump_played = true

@onready var character: Character = $".."
@onready var audio_jump: AudioStreamPlayer2D = $AudioJump
@onready var ledge_grab_node: Node2D = $"../LedgeGrabNode"


func _physics_process(_delta: float) -> void:
	if not audio_jump_played:
		if not character.is_on_floor() and not ledge_grab_node.is_holding_onto_ledge:
			audio_jump.play()
			audio_jump_played = true
	
	
	if character.is_on_floor() or ledge_grab_node.is_holding_onto_ledge:
		audio_jump_played = false
