extends Sprite2D

var anim := "idle"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character: Character = $"../.."
@onready var state_node: Node2D = $"../../StateNode"


func process() -> void:
	var new_anim = ""
	if state_node.state == state_node.DASH:
		new_anim = "dash"
	elif state_node.state == state_node.LEDGE_GRAB:
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


func play_explode() -> void:
	animation_player.play("explode")
