extends CharacterBody2D
class_name Character

## Direction the character is facing.
var direction_facing := Game.RIGHT

## Store player input.
var x_input := 0.0

@onready var state_node: Node = $StateNode


func _ready() -> void:
	state_node.change_state_to(state_node.NORMAL_MOVEMENT)


func _physics_process(delta) -> void:
	x_input = Input.get_axis("left", "right")


func die() -> void:
	state_node.change_state_to(state_node.DIE)


func bounce(bounce_vel: float = 0.0) -> void:
	velocity.y = -bounce_vel
	$StateNode/DashNode.times_dashed = 0
	$StateNode/MovementNode.jumped = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explode":
		Game.reset_level()
