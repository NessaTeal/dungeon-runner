extends Node
class_name ImmolationComponent

var stored_immolation: float = 0
@export var immolation_storage_coefficient = 0.0
@export var immolation = 0.0

@export var fighting_component: FightingComponent
@export var health_component: HealthComponent
@export var attack_component: AttackComponent

func _on_timeout():
	if fighting_component.fighting:
		if immolation > 0:
			attack_component.perform_attack(immolation * health_component.max_hp / 4)
	elif immolation_storage_coefficient > 0:
		stored_immolation = min(stored_immolation + immolation * health_component.max_hp, immolation_storage_coefficient * health_component.max_hp)

func _on_encounter_started():
	if stored_immolation > 0:
		get_tree().create_timer(0.15).timeout.connect(func(): 
			attack_component.perform_attack(stored_immolation)
			stored_immolation = 0
		)
