extends CharacterBody3D
class_name Enemy

@export var attack_component: AttackComponent
@export var health_component: HealthComponent

signal unit_died

var player: Player

func _on_health_component_hp_depleted() -> void:
	unit_died.emit()
	queue_free()
