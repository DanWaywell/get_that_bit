extends Node2D

enum States {STOP, NORMAL_MOVEMENT, DASH, LEDGE_GRAB, DIE}

var state := States.STOP

@onready var character: Character = $".."

@onready var movement_node: Node2D = $MovementNode
@onready var ledge_grab_node: Node2D = $LedgeGrabNode
@onready var dash_node: Node2D = $DashNode


@onready var collision_shape: CollisionShape2D = $"../CollisionShape"
@onready var direction_node: Node2D = $"../DirectionNode"
@onready var sprite: Sprite2D = $"../DirectionNode/Sprite"
@onready var sfx: Node2D = $"../Sfx"


func _ready() -> void:
	change_state_to(States.NORMAL_MOVEMENT)


func _physics_process(delta: float) -> void:	
	# process state
	match state:
		States.STOP:
			pass
		States.NORMAL_MOVEMENT:
			# process
			movement_node.process(delta)
			direction_node.process()
			sprite.process()
			dash_node.check_to_reset_dash()
			# check for exit conditions
			ledge_grab_node.check_for_ledge_grab()
			dash_node.check_for_dash()
		States.DASH:
			dash_node.process()
			sprite.process()
			dash_node.check_to_stop_dash()
		States.LEDGE_GRAB:
			# process
			ledge_grab_node.process(delta)
			sprite.process()
			# check for exit conditions
			ledge_grab_node.check_to_leave_ledge_grab()
			dash_node.check_for_dash()
		States.DIE:
			pass


func change_state_to(new_state: States) -> void:
	if state != new_state:
		# Exit from state (stop state)
		match state:
			States.STOP:
				pass
			States.NORMAL_MOVEMENT:
				pass
			States.DASH:
				dash_node.stop_dash()
			States.LEDGE_GRAB:
				pass
			States.DIE:
				pass
		# Enter new state (start state)
		match new_state:
			States.STOP:
				pass
			States.NORMAL_MOVEMENT:
				pass
			States.DASH:
				dash_node.start_dash()
			States.LEDGE_GRAB:
				dash_node.reset_dash()
			States.DIE:
				character.velocity = Vector2()
				collision_shape.set_deferred("disabled", true)
				sprite.play_explode()
				sfx.play_explode()
			_:
				print("error No State: " + str(new_state))
				
		# set state to new state
		state = new_state
