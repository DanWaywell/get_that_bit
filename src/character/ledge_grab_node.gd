extends Node2D

var is_holding_onto_ledge := false
var jump_multiplyer := 1.1

var ledge: Node2D = null

@onready var character: Character = $".."
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_forward: RayCast2D = $RayCastForward
@onready var timer: Timer = $Timer


func _physics_process(_delta) -> void:
	if not is_holding_onto_ledge:
		
		scale.x = character.direction_facing
		
		if ledge_is_there():
			
			set_holding_on_to_ledge(true)
		
	else:# is_holding_onto_ledge
		if ledge_is_moving_platform():
			keep_character_positioned_with_platform()
		
		if Input.is_action_just_pressed("jump"):
			jump_off_ledge()
			
		elif Input.is_action_just_pressed("down"):
			drop_off_ledge()

# must be in contact with ledge
func set_holding_on_to_ledge(value: bool = true):
	if value == true:
		is_holding_onto_ledge = true
				
		character.movement_node.stop()
		
		character.sprite.can_flip = false
		
		ledge = ray_cast_down.get_collider()
		
		disable_ray_casts()

		
		position_character_to_ledge()
	
	else:
		is_holding_onto_ledge = false
		
		character.movement_node.start()
		
		character.sprite.can_flip = true
		
		timer.start()# enable rays
		

func jump_off_ledge() -> void:
	set_holding_on_to_ledge(false)
	character.movement_node.jump(jump_multiplyer)
	
	
func drop_off_ledge() -> void:
	set_holding_on_to_ledge(false)


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


func disable_ray_casts(value: bool = true):
	if value == true:
		ray_cast_down.enabled = false
		ray_cast_forward.enabled = false
		ray_cast_up.enabled = false
	else:
		ray_cast_down.enabled = true
		ray_cast_forward.enabled = true
		ray_cast_up.enabled = true


func keep_character_positioned_with_platform() -> void:
	if scale.x == 1:
		character.position.x = ledge.position.x - 11
		character.position.y = ledge.position.y
	else:
		character.position.x = ledge.position.x + 11
		character.position.y = ledge.position.y


func position_character_to_ledge() -> void:
	if character.direction_facing == Game.RIGHT:
		character.position.x = ray_cast_forward.get_collision_point().x - 3
		character.position.y = ray_cast_down.get_collision_point().y + 4
	else:
		character.position.x = ray_cast_forward.get_collision_point().x + 3
		character.position.y = ray_cast_down.get_collision_point().y + 4


func _on_timer_timeout() -> void:
	disable_ray_casts(false)
