extends Collectible
class_name Apple

func _on_body_entered(player: Player) -> void:
	Meta.collected_resources.apples += CurrentRunState.apples_per_apples
	player.health_component.heal_damage(CurrentRunState.apple_healing)
	queue_free()
