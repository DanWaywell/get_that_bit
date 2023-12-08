extends CharacterBody2D
class_name Character

## Direction the character is facing.
var direction_facing := Game.RIGHT

## Store player input.
var input := 0.0

@onready var movement_node: Node2D = $MovementNode
@onready var ledge_grab_node: Node2D = $LedgeGrabNode

@onready var sprite: Sprite2D = $Sprite
@onready var sfx: Node2D = $Sfx


func _ready() -> void:
	pass


# Get input and process movement.
func _physics_process(_delta) -> void:
	input = Input.get_axis("left", "right")
	direction_facing = get_direction_facing(input, direction_facing)


## Stop the character physics process and reset values.
func stop() -> void:
	pass


## Start the character physics process.
func start() -> void:
	pass


## Restart level.
func die() -> void:
	set_physics_process(false)
	$LedgeGrabNode.set_physics_process(false)
	$Sfx.set_physics_process(false)
	$Sfx/AudioExplode.play()
	$Sprite/AnimationPlayer.play("explode")


# Set direction facing according to player input.
func get_direction_facing(_input, _direction_facing) -> int:
	if _input > 0:
		return Game.RIGHT
	elif _input < 0:
		return Game.LEFT
	else:
		return _direction_facing


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explode":
		Game.reset_level()
