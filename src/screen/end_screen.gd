extends Control


func _process(delta):
	if Input.is_action_just_pressed("jump")\
	or Input.is_action_just_pressed("ui_accept"):
		Game.reset()


func _on_timer_restart_timeout():
	Game.reset()