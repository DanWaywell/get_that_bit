extends Node






func _physics_process(delta: float) -> void:
	if ledge_grab_node.is_holding_onto_ledge:
		ledge_grab_node.process(delta)
		ledge_grab_node.check_to_leave_ledge_grab()
	else:
		direction_facing = get_direction_facing(x_input, direction_facing)
		movement_node.process(delta)
		ledge_grab_node.check_for_ledge()
		sprite.process(delta)


# Set direction facing according to player input.
func get_direction_facing(input, current_direction) -> int:
	if input > 0:
		return Game.RIGHT
	elif input < 0:
		return Game.LEFT
	else:
		return current_direction
