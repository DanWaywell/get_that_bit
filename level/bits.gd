extends Node2D

signal all_bits_got


func _physics_process(_delta):
	if get_child_count() == 0:
		all_bits_got.emit()
		set_physics_process(false)
