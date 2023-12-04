extends Node2D

var on_ledge := false

@onready var character: Character = $".."
@onready var ray_cast_down := $RayCastDown
@onready var ray_cast_up := $RayCastUp
@onready var ray_cast_forward := $RayCastForward
@onready var timer := $Timer


func _physics_process(_delta):
	if character.direction_facing == Vector2.LEFT:
		scale.x = -1
	else:
		scale.x = 1
	
	# delay to not get ledge grab when just jumping a single tile high
	if character.is_on_floor() and Input.is_action_just_pressed("jump"):
		ray_cast_down.enabled = false
		timer.start(0.2)
	
	if not character.is_on_floor() and not on_ledge\
	and ray_cast_down.is_colliding() and not ray_cast_up.is_colliding():
		
		# Start ledge grab
		on_ledge = true
		ray_cast_down.enabled = false

		character.stop()
		if character.direction_facing == Vector2.RIGHT:
			character.position.x = ray_cast_forward.get_collision_point().x - 3
			character.position.y = ray_cast_down.get_collision_point().y + 4
		else:
			character.position.x = ray_cast_forward.get_collision_point().x + 3
			character.position.y = ray_cast_down.get_collision_point().y + 4
	
	# Stop ledge grab
	if on_ledge == true:
		
		if Input.is_action_just_pressed("jump"):
			on_ledge = false
			timer.start()
			character.start()
			character.jump()
			
		elif Input.is_action_just_pressed("down"):
			on_ledge = false
			timer.start()
			character.start()


func _on_timer_timeout():
	ray_cast_down.enabled = true
