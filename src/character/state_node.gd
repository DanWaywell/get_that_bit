extends Node2D

enum {STOP, NORMAL_MOVEMENT, DASH, LEDGE_GRAB, DIE}

var state := STOP

@onready var character: Character = $".."

@onready var movement_node: Node2D = $MovementNode
@onready var ledge_grab_node: Node2D = $LedgeGrabNode
@onready var dash_node: Node2D = $DashNode


@onready var collision_shape: CollisionShape2D = $"../CollisionShape"
@onready var direction_node: Node2D = $"../DirectionNode"
@onready var sprite: Sprite2D = $"../DirectionNode/Sprite"
@onready var sfx: Node2D = $"../Sfx"


func _physics_process(delta: float) -> void:	
	# process state
	match state:
		STOP:
			pass
		NORMAL_MOVEMENT:
			# process
			movement_node.process(delta)
			direction_node.process()
			sprite.process()
			dash_node.check_to_reset_dash()
			# check for exit conditions
			ledge_grab_node.check_for_ledge_grab()
			dash_node.check_for_dash()
		DASH:
			dash_node.process()
			sprite.process()
			dash_node.check_to_stop_dash()
		LEDGE_GRAB:
			# process
			ledge_grab_node.process(delta)
			sprite.process()
			# check for exit conditions
			ledge_grab_node.check_to_leave_ledge_grab()
			dash_node.check_for_dash()
		DIE:
			pass


func change_state_to(new_state: int) -> void:
	if state != new_state:
		# Exit from state (stop state)
		match state:
			STOP:
				pass
			NORMAL_MOVEMENT:
				pass
			DASH:
				dash_node.stop_dash()
			LEDGE_GRAB:
				pass
			DIE:
				pass
		# Enter new state (start state)
		match new_state:
			STOP:
				pass
			NORMAL_MOVEMENT:
				pass
			DASH:
				dash_node.start_dash()
			LEDGE_GRAB:
				dash_node.reset_dash()
			DIE:
				character.velocity = Vector2()
				collision_shape.set_deferred("disabled", true)
				sprite.play_explode()
				sfx.play_explode()
			_:
				print("error No State: " + str(new_state))
				
		# set state to new state
		state = new_state
