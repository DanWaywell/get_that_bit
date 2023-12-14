extends Node2D

const SPEED = 46.0
const DEFAULT_GRAVITY = 240.0
const FALL_MULTIPLYER = 1.1
const JUMP_VELOCITY = -70.0
const JUMP_REDUCTION = 0.5
const COYOTE_TIME = 0.1
const PREJUMP_TIME = 0.1
const GROUND_ACCEL = 0.5
const GROUND_DECEL = 0.4
const AIR_ACCEL = 0.1
const AIR_DECEL = 0.02

var gravity := DEFAULT_GRAVITY
var air_time := 0.0
var jumped := false

@onready var character: Character = $"../.."
@onready var timer_prejump := $TimerPrejump
@onready var sfx: Node2D = $"../../Sfx"


func process(delta: float) -> void:
	if not character.is_on_floor():
		air_time += delta
		process_gravity(delta)
	else:
		air_time = 0.0
		jumped = false
	
	process_jumping()
	if jumped:
		process_reduce_jump()
	process_x_movement()
	character.move_and_slide()


## Makes the character jump.
## Designed to be used with no arguments or just a multiplyer.
func jump(multiplyer: float = 1.0, jump_velocity: float = JUMP_VELOCITY) -> void:
	if not jumped:
		jumped = true
		character.velocity.y = jump_velocity * multiplyer
		sfx.play_jump()


# Process Gravity and add multiplier for faster falling.
func process_gravity(delta) -> void:
	if character.velocity.y > 0:
		character.velocity.y += gravity * delta
	else:
		character.velocity.y += gravity * FALL_MULTIPLYER * delta


# Process jump with detection for early and late button presses.
func process_jumping() -> void:
	if Input.is_action_just_pressed("jump"):
		timer_prejump.start(PREJUMP_TIME)
		
	if not timer_prejump.is_stopped() and air_time < COYOTE_TIME:
		if Input.is_action_pressed("jump"):
			jump()
		else:
			jump(JUMP_REDUCTION)
		timer_prejump.stop()


# Process jump reduction.
func process_reduce_jump() -> void:
	if character.velocity.y < 0 and Input.is_action_just_released("jump") and jumped:
		
		character.velocity.y *= JUMP_REDUCTION


# Process movement on ground or in air with acceleration and deceleration.
func process_x_movement() -> void:
	if character.x_input:
		if character.is_on_floor():
			character.velocity.x = lerp(character.velocity.x, character.x_input * SPEED, GROUND_ACCEL)
		else:
			character.velocity.x = lerp(character.velocity.x, character.x_input * SPEED, AIR_ACCEL)
	else:
		if character.is_on_floor():
			character.velocity.x = lerp(character.velocity.x, character.x_input * SPEED, GROUND_DECEL)
		else:
			character.velocity.x = lerp(character.velocity.x, 0.0, AIR_DECEL)


func reset():
	character.velocity = Vector2()
	air_time = 0.0
	jumped = false
	timer_prejump.stop()
