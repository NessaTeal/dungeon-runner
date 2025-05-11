extends Area2D
class_name EnemyCollisionComponent

var is_colliding = false
@export var attack_component: AttackComponent
@export var health_component: HealthComponent
@export var contact_damage: float = 10.0

func _on_area_entered(area: Area2D) -> void:
	is_colliding = true

func _on_area_exited(area: Area2D) -> void:
	is_colliding = false

func _process(delta: float) -> void:
	if is_colliding:
		attack_component.perform_attack(contact_damage * delta)

func receive_attack(damage: float):
	health_component._on_receive_damage(damage)
