extends Node
class_name RetaliationComponent

@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var retaliate = 0.0

func _on_unit_attacked(damage: float):
	if retaliate < 0:
		attack_component.perform_attack(damage * retaliate)

func reset():
	retaliate = 0.0
