extends CharacterBody2D
class_name Character
## Class to process basic platforming movement.
## Moving left and right and jumping.
## With functions for starting and stopping so other nodes
## can take over, eg LedgeGrabNode.

const SPEED = 46.0
const DEFAULT_GRAVITY = 240.0
const FALL_MULTIPLYER = 1.1
const JUMP_VELOCITY = -70.0
const COYOTE_TIME = 0.1
const JUMP_REDUCTION = 0.4
const PREJUMP_TIME = 0.1
const GROUND_ACCEL = 0.5
const GROUND_DECEL = 0.4
const AIR_ACCEL = 0.1
const AIR_DECEL = 0.02

## Gravity to be applied to the character.
var gravity := DEFAULT_GRAVITY
## Direction the character is facing.
var direction_facing := Vector2.RIGHT

# For counting time spent off of the ground.
var _air_time := 0.0
# To Store player input.
var _input := 0.0
# For when jump button pressed a bit early
@onready var _timer_prejump := $TimerPrejump


# Get input and process movement.
func _physics_process(delta) -> void:
	_input = Input.get_axis("left", "right")
	
	if not is_on_floor():
		_air_time += delta
		_process_gravity(delta)
	else:
		_air_time = 0.0
	
	_process_direction_facing()
	_process_jumping()
	_process_reduce_jump()
	_process_x_movement()
	move_and_slide()


## Stop the character physics process and reset values.
func stop() -> void:
	set_physics_process(false)
	_air_time = 0.0
	velocity = Vector2()
	_timer_prejump.stop()


## Start the character physics process.
func start() -> void:
	set_physics_process(true)


## Makes the character jump.
## Designed to be used with no arguments or just a multiplyer.
func jump(multiplyer: float = 1.0, jump_velocity: float = JUMP_VELOCITY) -> void:
	velocity.y = jump_velocity * multiplyer


## Restart level.
func die() -> void:
	Game.reset_level()


# Process Gravity and add multiplier for faster falling.
func _process_gravity(delta) -> void:
	if velocity.y > 0:
		velocity.y += gravity * delta
	else:
		velocity.y += gravity * FALL_MULTIPLYER * delta


# Process jump with detection for early and late button presses.
func _process_jumping() -> void:
	if Input.is_action_just_pressed("jump"):
		_timer_prejump.start(PREJUMP_TIME)
		
	if not _timer_prejump.is_stopped() and _air_time < COYOTE_TIME:
		if Input.is_action_pressed("jump"):
			jump()
		else:
			jump(JUMP_REDUCTION)
		_timer_prejump.stop()


# Process jump reduction.
func _process_reduce_jump() -> void:
	if velocity.y < 0 and Input.is_action_just_released("jump"):
		velocity.y *= JUMP_REDUCTION


# Process movement on ground and in air with acceleration and deceleration.
func _process_x_movement() -> void:
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


# Set direction facing according to player input.
func _process_direction_facing() -> void:
	if _input > 0:
		direction_facing = Vector2.RIGHT
	elif _input < 0:
		direction_facing = Vector2.LEFT
