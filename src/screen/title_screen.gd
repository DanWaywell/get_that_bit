extends Control

@onready var button_start = $ButtonStart


func _ready():
	button_start.grab_focus()


func _process(delta):
	if Input.is_action_just_pressed("jump"):
		Game.start()


func _on_button_start_pressed():
	Game.start()
