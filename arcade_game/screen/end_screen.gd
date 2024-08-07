extends Control


func _process(_delta):
	if Input.is_action_just_pressed("jump1")\
	or Input.is_action_just_pressed("ui_accept"):
		Game.reset_game()


func _on_timer_restart_timeout():
	Game.reset_game()
