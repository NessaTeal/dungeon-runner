extends Area3D
class_name EnemyHurtboxComponent

@export var health_component: HealthComponent

func receive_attack(damage: float) -> void:
	health_component._on_receive_damage(damage)
