extends CharacterBody2D
class_name Character

## Direction the character is facing.
var direction_facing := Game.RIGHT

## Store player input.
var x_input := 0.0

@onready var movement_node: Node2D = $MovementNode
@onready var ledge_grab_node: Node2D = $LedgeGrabNode

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var area_crush: Area2D = $AreaCrush
@onready var sprite: Sprite2D = $Sprite
@onready var sfx: Node2D = $Sfx


func _physics_process(delta) -> void:
	x_input = Input.get_axis("left", "right")


## Restart level.
func die() -> void:
	set_physics_process(false)
	collision_shape.set_deferred("disabled", true)
	area_crush.set_deferred("monitoring", false)
	area_crush.set_deferred("monitorable", false)
	sprite.play_explode()
	sfx.play_explode()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explode":
		Game.reset_level()
