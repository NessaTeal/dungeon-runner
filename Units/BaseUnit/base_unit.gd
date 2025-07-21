extends Node3D

class_name BaseUnit

@export var unit_name: String = 'Unit Name'

#@onready var unit_name_label: Label = $Name
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent

signal hp_updated(current_hp, max_hp)
signal unit_died

var components = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	components.merge({
		HealthComponent: health_component,
		AttackComponent: attack_component
	})

func get_2d_position() -> Vector2:
	return Vector2(position.x, position.z)

func _process(_delta: float) -> void:
	$"2DComponents".position = get_2d_position()
