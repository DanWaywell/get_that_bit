extends Control

var Game

@onready var button_start: TextureButton = $ButtonStart


func _ready():
	Game = get_parent()
	button_start.grab_focus()


func _process(_delta):
	if Input.is_action_just_pressed("jump1"):
		Game.start()


func _on_button_start_pressed():
	Game.start()
