extends Node2D

enum {STOP, NORMAL_MOVEMENT, LEDGE_GRAB, DIE}

var state := STOP

@onready var character: Character = $".."

@onready var movement_node: Node = $MovementNode
@onready var ledge_grab_node: Node = $LedgeGrabNode

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
			sprite.process(delta)
			# check for exit conditions
			ledge_grab_node.check_for_ledge_grab()
		LEDGE_GRAB:
			# process
			ledge_grab_node.process(delta)
			sprite.process(delta)
			# check for exit conditions
			ledge_grab_node.check_to_leave_ledge_grab()
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
			LEDGE_GRAB:
				pass
			DIE:
				collision_shape.set_deferred("disabled", true)
				sprite.play_explode()
				sfx.play_explode()
			_:
				print("error No State: " + str(new_state))
				
		# set state to new state
		state = new_state
