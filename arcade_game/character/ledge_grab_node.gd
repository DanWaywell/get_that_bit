extends Node2D

const LEDGE_OFFSET_X = 3
const LEDGE_OFFSET_Y = 5
const MOVING_PLATFORM_X_OFFSET = 11
const MOVING_PLATFORM_Y_OFFSET = 1

var is_holding_onto_ledge := false
var jump_multiplyer := 1.1

var ledge: Node2D = null

@onready var character: Character = $"../.."
@onready var state_node: Node2D = $".."
@onready var movement_node: Node2D = $"../MovementNode"

@onready var timer: Timer = $Timer
@onready var ray_cast_down: RayCast2D = $"../../DirectionNode/LedgeGrabRays/RayCastDown"
@onready var ray_cast_up: RayCast2D = $"../../DirectionNode/LedgeGrabRays/RayCastUp"
@onready var ray_cast_forward: RayCast2D = $"../../DirectionNode/LedgeGrabRays/RayCastForward"


func process(_delta) -> void:
	if ledge.is_in_group("moving_platform"):
		keep_character_positioned_with_platform()


func check_for_ledge_grab() -> void:
	if timer.is_stopped():
		if ledge_is_there():
			grab_ledge()


func check_to_leave_ledge_grab() -> void:
	if Input.is_action_just_pressed(character.btn_jump):
		jump_off_ledge()
	elif Input.is_action_just_pressed(character.btn_down):
		let_go_of_ledge()


# Ray must be in contact with ledge
func grab_ledge() -> void:
	state_node.change_state_to(state_node.States.LEDGE_GRAB)
	movement_node.reset()
	ledge = ray_cast_forward.get_collider()
	position_character_to_ledge()


func let_go_of_ledge() -> void:
	state_node.change_state_to(state_node.States.NORMAL_MOVEMENT)
	timer.start()
		

func jump_off_ledge() -> void:
	let_go_of_ledge()
	movement_node.jump(jump_multiplyer)
	

func ledge_is_there() -> bool:
	ray_cast_down.force_raycast_update()
	ray_cast_forward.force_raycast_update()
	ray_cast_up.force_raycast_update()
	
	if not character.is_on_floor()\
	and ray_cast_down.is_colliding()\
	and ray_cast_forward.is_colliding()\
	and not ray_cast_up.is_colliding():
		return true
	else:
		return false


func keep_character_positioned_with_platform() -> void:
	if character.direction_facing == Vector2.RIGHT:
		character.position.x = ledge.position.x - MOVING_PLATFORM_X_OFFSET
		character.position.y = ledge.position.y + MOVING_PLATFORM_Y_OFFSET
	else:
		character.position.x = ledge.position.x + MOVING_PLATFORM_X_OFFSET
		character.position.y = ledge.position.y + MOVING_PLATFORM_Y_OFFSET


func position_character_to_ledge() -> void:
	if character.direction_facing == Vector2.RIGHT:
		character.position.x = ray_cast_forward.get_collision_point().x - LEDGE_OFFSET_X
		character.position.y = ray_cast_down.get_collision_point().y + LEDGE_OFFSET_Y
	else:
		character.position.x = ray_cast_forward.get_collision_point().x + LEDGE_OFFSET_X
		character.position.y = ray_cast_down.get_collision_point().y + LEDGE_OFFSET_Y
