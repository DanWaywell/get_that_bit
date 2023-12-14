extends CharacterBody2D
class_name Character

@export var player_number = 1

## Direction the character is facing.
var direction_facing := Game.RIGHT

## Store player input.
var x_input := 0.0

# button strings
var btn_left = "left"
var btn_right = "right"
var btn_up = "up"
var btn_down = "down"
var btn_jump = "jump"
var btn_dash = "dash"

@onready var state_node: Node = $StateNode


func _ready() -> void:
	btn_left += str(player_number)
	btn_right += str(player_number)
	btn_up += str(player_number)
	btn_down += str(player_number)
	btn_jump += str(player_number)
	btn_dash += str(player_number)
	
	state_node.change_state_to(state_node.NORMAL_MOVEMENT)


func _physics_process(delta) -> void:
	x_input = Input.get_axis(btn_left, btn_right)


func die() -> void:
	state_node.change_state_to(state_node.DIE)


func bounce(bounce_velocity := 100.0) -> void:
	state_node.movement_node.bounce(bounce_velocity)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explode":
		Game.reset_level()
