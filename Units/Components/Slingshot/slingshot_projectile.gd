extends Area2D
class_name SlingshotProjectile

var damage = 0
var attack_component: AttackComponent

func _process(delta):
	position.x += 1000 * delta

func _on_area_entered(area):
	if area is HitboxComponent:
		attack_component.perform_attack(damage)
		queue_free()
