extends Node2D

var holding_on_to_ledge := false
var jump_multiplyer := 1.1

var ledge: Node2D = null

@onready var character: Character = $".."
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_forward: RayCast2D = $RayCastForward
@onready var timer: Timer = $Timer


func _physics_process(_delta) -> void:
	if not holding_on_to_ledge:
		
		_set_direction_of_node_to_character_direction()
		
		if _ledge_is_there():
			
			_set_holding_on_to_ledge(true)
		
	else:# holding_on_to_ledge
		if _ledge_is_moving_platform():
			_keep_character_positioned_with_platform()
		
		if Input.is_action_just_pressed("jump"):
			jump_off_ledge()
			
		elif Input.is_action_just_pressed("down"):
			drop_off_ledge()

# must be in contact with ledge
func _set_holding_on_to_ledge(value: bool = true):
	if value == true:
		holding_on_to_ledge = true
				
		ledge = ray_cast_down.get_collider()
		
		_disable_ray_casts()

		character.stop()
		
		_position_character_to_ledge()
	
	else:
		holding_on_to_ledge = false
		timer.start()
		character.start()

func jump_off_ledge() -> void:
	_set_holding_on_to_ledge(false)
	character.jump(jump_multiplyer)
	
	
func drop_off_ledge() -> void:
	_set_holding_on_to_ledge(false)


func _ledge_is_there() -> bool:
	if not character.is_on_floor() and ray_cast_down.is_colliding() and not ray_cast_up.is_colliding():
		return true
	else:
		return false


func _ledge_is_moving_platform() -> bool:
	var collider = ray_cast_down.get_collider()
	if collider.is_in_group("moving_platform"):
		return true
	else:
		return false


func _disable_ray_casts(value: bool = true):
	if value == true:
		ray_cast_down.enabled = false
		ray_cast_forward.enabled = false
		ray_cast_up.enabled = false
	else:
		ray_cast_down.enabled = true
		ray_cast_forward.enabled = true
		ray_cast_up.enabled = true


func _set_direction_of_node_to_character_direction() -> void:
	if character.direction_facing == Vector2.LEFT:
		scale.x = -1
	else:
		scale.x = 1


func _keep_character_positioned_with_platform() -> void:
	if scale.x == 1:
		character.position.x = ledge.position.x - 11
		character.position.y = ledge.position.y
	else:
		character.position.x = ledge.position.x + 11
		character.position.y = ledge.position.y


func _position_character_to_ledge() -> void:
	if character.direction_facing == Vector2.RIGHT:
		character.position.x = ray_cast_forward.get_collision_point().x - 3
		character.position.y = ray_cast_down.get_collision_point().y + 4
	else:
		character.position.x = ray_cast_forward.get_collision_point().x + 3
		character.position.y = ray_cast_down.get_collision_point().y + 4


func _on_timer_timeout() -> void:
	_disable_ray_casts(false)
