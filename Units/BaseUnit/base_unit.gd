extends Node3D
class_name BaseUnit

@export var unit_name: String = 'Unit Name'
@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var _2d_components: Node2D

signal unit_died

func get_2d_position() -> Vector2:
	return Vector2(position.x, position.z)

func _process(_delta: float) -> void:
	_2d_components.position = get_2d_position()

func _on_health_component_hp_depleted() -> void:
	unit_died.emit()
	queue_free()
