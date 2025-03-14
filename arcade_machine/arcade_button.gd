extends Node3D

@export var connected_button := ""
@export var color := Color.WHITE

@onready var button_base := $ButtonBase
@onready var button_top := $ButtonTop


func _ready() -> void:
	var newMaterial = StandardMaterial3D.new()
	newMaterial.albedo_color = color
	button_base.set_surface_override_material(0, newMaterial)
	button_top.set_surface_override_material(0, newMaterial)


func _process(_delta: float) -> void:
	if connected_button == "":
		pass
	else:
		if Input.is_action_pressed(connected_button):
			$ButtonTop.position.y = -0.004
		else:
			$ButtonTop.position.y = 0.0
