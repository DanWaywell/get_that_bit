extends CharacterBody3D

@onready var camera = $CameraRotation/Camera3D
@onready var camera_rotation = $CameraRotation
@onready var ray_cast = $CameraRotation/Camera3D/RayCast3D


var mouse_sensitivity = 0.004
var joypad_sensertivity = 4
var joypad_deadzone = 0.2
var speed = 4.0
var jump_speed = 8.0
var gravity = 30
var active_controller = true


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _unhandled_input(event):
	# Mouse look input
	if active_controller:
		if event is InputEventMouseMotion:
			camera_rotation.rotate_y(-event.relative.x * mouse_sensitivity)
			
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)


func _physics_process(delta):
	# Dev only (coment out later)
	#if Input.is_action_pressed("dev_free_mouse"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if active_controller:
		# Gamepad look input
		var look_input = get_look_input()
		if look_input:
			camera_rotation.rotate_y(deg_to_rad(look_input.x * joypad_sensertivity))
			
			camera.rotate_x(deg_to_rad(look_input.y * joypad_sensertivity))
			camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		
		# Move input
		var direction = get_move_input()
		direction = direction.rotated(Vector3.UP, camera_rotation.rotation.y)
		
		# X Z Velocity
		if direction:
			velocity.x = direction.x * speed + direction.normalized().x
			velocity.z = direction.z * speed + direction.normalized().z
		else:
			velocity.x = 0
			velocity.z = 0
		
		# Y velocity
		velocity.y -= gravity * delta
		if Input.is_action_just_pressed("jump1") and is_on_floor():
			velocity.y = jump_speed

		move_and_slide()
		
		if Input.is_action_just_pressed("interact1"):
			if ray_cast.is_colliding():
				if ray_cast.get_collider().get_parent().name == "ArcadeMachine":
					active_controller = false
					var arcade_machine = ray_cast.get_collider().get_parent()
					arcade_machine.activate()
					if not arcade_machine.is_game_playing:
						arcade_machine.start_game()
						arcade_machine.is_game_playing = true
	
	else:
		if Input.is_action_just_pressed("interact1"):
			active_controller = true
			ray_cast.get_collider().get_parent().deactivate()
			


func get_look_input():
	var input = Vector2()
	input.x = Input.get_action_strength("look_left1") - Input.get_action_strength("look_right1")
	input.y = Input.get_action_strength("look_up1") - Input.get_action_strength("look_down1")
	
	if input.length() < joypad_deadzone:
		input = Vector2()
	else:
		input = input.normalized() * ((input.length() - joypad_deadzone) / (1 - joypad_deadzone))
	
	return input.limit_length(1.0)


func get_move_input():
	var input = Vector2()
	input.x =  Input.get_action_strength("right1") - Input.get_action_strength("left1")
	input.y =  Input.get_action_strength("down1") - Input.get_action_strength("up1")
	
	if input.length() < joypad_deadzone:
		input = Vector2()
	else:
		input = input.normalized() * ((input.length() - joypad_deadzone) / (1 - joypad_deadzone))
	
	input = input.limit_length(1.0)
	
	return Vector3(input.x, 0, input.y)
