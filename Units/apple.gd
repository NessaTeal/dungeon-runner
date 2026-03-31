extends Collectible
class_name Apple

func _on_body_entered(player: Player) -> void:
	Meta.apples += CurrentRunState.apples_per_apples
	player.health_component.heal_damage(CurrentRunState.apple_healing)
	queue_free()
