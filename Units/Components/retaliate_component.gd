extends Node

@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var retaliate = 0.0

func _on_unit_attacked(damage: float):
	attack_component.perform_attack(damage * retaliate)
