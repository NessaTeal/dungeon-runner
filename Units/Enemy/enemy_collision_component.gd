extends Area3D
class_name EnemyCollisionDamageComponent

var is_colliding := false
@export var attack_component: AttackComponent
@export var contact_damage: float = 10.0

func _process(delta: float) -> void:
	if is_colliding:
		attack_component.perform_attack(contact_damage * delta)

func _on_body_entered(_body: Player) -> void:
	is_colliding = true

func _on_body_exited(_body: Player) -> void:
	is_colliding = false
