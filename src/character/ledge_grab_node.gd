extends Node2D

var on_ledge = false
var delay = true

@onready var character = $".."
@onready var ray_cast = $RayCast
@onready var ray_cast_2 = $RayCast2
@onready var ray_cast_3 = $RayCast3
@onready var timer = $Timer


func _physics_process(delta):
	if character.direction_facing == Vector2.LEFT:
		scale.x = -1
	else:
		scale.x = 1
	
	# delay to not get ledge grab when just jumping a single tile high
	if character.is_on_floor() and Input.is_action_just_pressed("jump"):
		ray_cast.enabled = false
		timer.start(0.2)
	
	# 
	if ray_cast.is_colliding()\
	and not ray_cast_2.is_colliding()\
	and not character.is_on_floor()\
	and not on_ledge:
		on_ledge = true
		character.active = false
		character.velocity = Vector2()
		character.air_timer = 0.0
		ray_cast.enabled = false

		if character.direction_facing == Vector2.RIGHT:
			character.position.x = ray_cast_3.get_collision_point().x - 3
			character.position.y = ray_cast.get_collision_point().y + 4
		else:
			character.position.x = ray_cast_3.get_collision_point().x + 3
			character.position.y = ray_cast.get_collision_point().y + 4
	
	if on_ledge == true:
		if Input.is_action_just_pressed("jump"):
			on_ledge = false
			character.active = true
			character.velocity.y = character.JUMP_VELOCITY
			timer.start()
		elif Input.is_action_just_pressed("down"):
			on_ledge = false
			character.active = true
			timer.start()


func _on_timer_timeout():
	ray_cast.enabled = true
