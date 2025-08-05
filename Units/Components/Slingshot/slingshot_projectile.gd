extends Area2D
class_name SlingshotProjectile

var damage := 0.0
var attack_component: AttackComponent

func _process(delta: float) -> void:
	position.x += 1000 * delta

func _on_area_entered(_area: Area2D) -> void:
	attack_component.perform_attack(damage)
	queue_free()
