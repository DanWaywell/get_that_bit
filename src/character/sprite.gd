extends Sprite2D

var anim := "idle"
var can_flip = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character: Character = $".."
@onready var ledge_grab_node: Node2D = $"../LedgeGrabNode"


func _physics_process(_delta) -> void:
	if can_flip:
		if character.direction_facing == Game.RIGHT:
			flip_h = false
		else:
			flip_h = true
	
	var new_anim = ""
	if ledge_grab_node.is_holding_onto_ledge:
		new_anim = "grab_ledge"
	elif character.is_on_floor():
		if abs(character.velocity.x) < 1:
			new_anim = "idle"
		else:
			new_anim = "run"
	else:
		if character.velocity.y < 0:
			new_anim = "jump"
		else:
			new_anim = "fall"
	
	if new_anim != anim:
		anim = new_anim
		animation_player.play(anim)
