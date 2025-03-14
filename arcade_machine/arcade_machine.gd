extends Node3D

@onready var cabinet = $ArcadeCabinet
@onready var game = $ArcadeCabinet/SubViewport/Game

var is_game_playing = false


func activate():
	cabinet.physics_interpolation_mode = 0
	cabinet.process_mode = 0

func deactivate():
	cabinet.physics_interpolation_mode = 2
	cabinet.process_mode = 4

func start_game():
	game.start()
