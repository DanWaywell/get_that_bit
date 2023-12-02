extends Sprite2D

var anim = "idle"

@onready var character = $".."
@onready var animation_player = $AnimationPlayer
@onready var ledge_grab_node = $"../LedgeGrabNode"


func _physics_process(delta):
	if character.direction_facing == Vector2.LEFT:
		flip_h = true
	else:
		flip_h = false
	
	var new_anim = ""
	if ledge_grab_node.on_ledge:
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