extends CharacterBody2D
class_name Character

const SPEED = 46.0
const DEFAULT_GRAVITY = 240.0
const JUMP_VELOCITY = -70.0
const COYOTE_TIME = 0.1
const JUMP_REDUCTION = 0.4
const GROUND_ACCEL = 0.5
const GROUND_DECEL = 0.4
const AIR_ACCEL = 0.1
const AIR_DECEL = 0.02

var active := true
var direction_facing := Vector2.RIGHT
var gravity := DEFAULT_GRAVITY

var _air_time := 0.0
var _input := 0.0

@onready var timer_prejump := $TimerPrejump


func _physics_process(delta):
	if active:
		_input = Input.get_axis("left", "right")
		_process_direction_facing()
		
		if not is_on_floor():
			_air_time += delta
			_process_gravity(delta)
		else:
			_air_time = 0.0
		
		_process_jump()
		_process_x_movement()
		move_and_slide()


func stop():
	active = false
	_air_time = 0.0
	velocity = Vector2()
	timer_prejump.stop()


func start():
	active = true


func jump():
	velocity.y = JUMP_VELOCITY


func crush(body):
	die()


func die():
	Game.reset_level()


func _process_gravity(delta):
	if velocity.y > 0:
		velocity.y += gravity * delta
	else:
		velocity.y += gravity * 1.1 * delta


func _process_jump():
	# Jump with detection for early button press, coyote time and jump reduction
	if Input.is_action_just_pressed("jump"):
		timer_prejump.start()
	if not timer_prejump.is_stopped() and _air_time < COYOTE_TIME:
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * JUMP_REDUCTION
		timer_prejump.stop()

	if velocity.y < 0 and Input.is_action_just_released("jump"):
		velocity.y *= JUMP_REDUCTION


func _process_x_movement():
	# movement on ground and in air with acceleration and deceleration
	if _input:
		if is_on_floor():
			velocity.x = lerp(velocity.x, _input * SPEED, GROUND_ACCEL)
		else:
			velocity.x = lerp(velocity.x, _input * SPEED, AIR_ACCEL)
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, _input * SPEED, GROUND_DECEL)
		else:
			velocity.x = lerp(velocity.x, 0.0, AIR_DECEL)


func _process_direction_facing():
	if _input > 0:
		direction_facing = Vector2.RIGHT
	elif _input < 0:
		direction_facing = Vector2.LEFT
