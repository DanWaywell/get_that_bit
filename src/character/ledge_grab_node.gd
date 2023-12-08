extends Node2D

const LEDGE_OFFSET_X = 3
const LEDGE_OFFSET_Y = 5
const MOVING_PLATFORM_X_OFFSET = 11
const MOVING_PLATFORM_Y_OFFSET = 1

var is_holding_onto_ledge := false
var jump_multiplyer := 1.1

var ledge: Node2D = null

@onready var character: Character = $".."
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_forward: RayCast2D = $RayCastForward
@onready var timer: Timer = $Timer


func process(_delta) -> void:
	if ledge_is_moving_platform():
		keep_character_positioned_with_platform()


func check_for_ledge() -> void:
	scale.x = character.direction_facing
	
	if ledge_is_there():
		grab_ledge()


func check_to_leave_ledge_grab() -> void:
	if Input.is_action_just_pressed("jump"):
		jump_off_ledge()
		
	elif Input.is_action_just_pressed("down"):
		let_go_of_ledge()


# Ray must be in contact with ledge
func grab_ledge() -> void:
	is_holding_onto_ledge = true
	
	ledge = ray_cast_down.get_collider()
	
	disable_ray_casts()
	
	character.movement_node.stop()
	
	position_character_to_ledge()


func let_go_of_ledge() -> void:
		is_holding_onto_ledge = false
		
		timer.start()# enable rays
		

func jump_off_ledge() -> void:
	let_go_of_ledge()
	character.movement_node.jump(jump_multiplyer)
	

func ledge_is_there() -> bool:
	if not character.is_on_floor()\
	and ray_cast_down.is_colliding()\
	and not ray_cast_up.is_colliding():
		return true
	else:
		return false


func ledge_is_moving_platform() -> bool:
	var collider = ray_cast_down.get_collider()
	if collider.is_in_group("moving_platform"):
		return true
	else:
		return false


func disable_ray_casts(value: bool = true) -> void:
	if value == true:
		ray_cast_down.enabled = false
		ray_cast_forward.enabled = false
		ray_cast_up.enabled = false
	else:
		ray_cast_down.enabled = true
		ray_cast_forward.enabled = true
		ray_cast_up.enabled = true


func keep_character_positioned_with_platform() -> void:
	if character.direction_facing == Game.RIGHT:
		character.position.x = ledge.position.x - MOVING_PLATFORM_X_OFFSET
		character.position.y = ledge.position.y + MOVING_PLATFORM_Y_OFFSET
	else:
		character.position.x = ledge.position.x + MOVING_PLATFORM_X_OFFSET
		character.position.y = ledge.position.y + MOVING_PLATFORM_Y_OFFSET


func position_character_to_ledge() -> void:
	if character.direction_facing == Game.RIGHT:
		character.position.x = ray_cast_forward.get_collision_point().x - LEDGE_OFFSET_X
		character.position.y = ray_cast_down.get_collision_point().y + LEDGE_OFFSET_Y
	else:
		character.position.x = ray_cast_forward.get_collision_point().x + LEDGE_OFFSET_X
		character.position.y = ray_cast_down.get_collision_point().y + LEDGE_OFFSET_Y


func _on_timer_timeout() -> void:
	disable_ray_casts(false)
