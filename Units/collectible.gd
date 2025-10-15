extends Area3D
class_name Collectible

func _on_body_entered(player: Player) -> void:
	Meta.apples += 1
	player.health_component.damaged = maxf(0.0, player.health_component.damaged - 100.0)
	queue_free()
