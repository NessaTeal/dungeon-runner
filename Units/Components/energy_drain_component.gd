extends Node
class_name EnergyDrainComponent

@export var health_component: HealthComponent

@export var energy_drain := 1.0
@export var energy_drain_acceleration := 0.1

func _process(delta: float) -> void:
	health_component.receive_damage_no_emit(energy_drain * delta)
	energy_drain += energy_drain_acceleration * delta
