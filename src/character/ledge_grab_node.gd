extends Node2D

var on_ledge := false
var can_turn := true

@onready var character: Character = $".."
@onready var ray_cast_down := $RayCastDown
@onready var ray_cast_up := $RayCastUp
@onready var ray_cast_forward := $RayCastForward
@onready var timer := $Timer


func _physics_process(_delta):
	if can_turn:
		var input := Input.get_axis("left", "right")
		if input < 0:
			scale.x = -1
		elif input > 0:
			scale.x = 1
	
	# Start ledge grab
	if not character.is_on_floor() and not on_ledge\
	and ray_cast_down.is_colliding() and not ray_cast_up.is_colliding():
		
		on_ledge = true
		can_turn = false
		ray_cast_down.enabled = false

		character.stop()
		if scale.x == 1:
			character.position.x = ray_cast_forward.get_collision_point().x - 3
			character.position.y = ray_cast_down.get_collision_point().y + 4
		else:
			character.position.x = ray_cast_forward.get_collision_point().x + 3
			character.position.y = ray_cast_down.get_collision_point().y + 4
	
	# Stop ledge grab
	if on_ledge == true:
		
		if Input.is_action_just_pressed("jump"):
			on_ledge = false
			can_turn = true
			timer.start()
			character.start()
			character.jump()
			
		elif Input.is_action_just_pressed("down"):
			on_ledge = false
			can_turn = true
			timer.start()
			character.start()


func _on_timer_timeout():
	ray_cast_down.enabled = true
