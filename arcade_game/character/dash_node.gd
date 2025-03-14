extends Node2D

const DASH_SPEED = 120.0
const DASH_DURATION = 0.1
const VELOCITY_DIVIDER = 1.5

var times_dashed = 0

@onready var character: Character = $"../.."
@onready var state_node: Node2D = $".."
@onready var direction_node: Node2D = $"../../DirectionNode"
@onready var timer: Timer = $Timer
@onready var collision_shape: CollisionShape2D = $"../../CollisionShape"
@onready var dash_collision_shape: CollisionShape2D = $"../../DashCollisionShape"


func check_for_dash():
	if Input.is_action_just_pressed(character.btn_dash) and times_dashed < 1:
		state_node.change_state_to(state_node.States.DASH)


func start_dash():
	if state_node.state == state_node.States.LEDGE_GRAB:
			direction_node.flip_direction()
	
	character.velocity.y = 0.0
	character.velocity.x = DASH_SPEED * character.direction_facing.x
	timer.start(DASH_DURATION)
	collision_shape.set_deferred("disabled", true)
	dash_collision_shape.set_deferred("disabled", false)
	
	times_dashed += 1


func process():
	character.move_and_slide()


func check_to_stop_dash():
	if timer.is_stopped():
		state_node.change_state_to(state_node.States.NORMAL_MOVEMENT)


func stop_dash():
	character.velocity.x /= VELOCITY_DIVIDER
	collision_shape.set_deferred("disabled", false)
	dash_collision_shape.set_deferred("disabled", true)


func check_to_reset_dash():
	if character.is_on_floor():
		reset_dash()

func reset_dash():
	times_dashed = 0
