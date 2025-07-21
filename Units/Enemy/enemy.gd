extends BaseUnit

class_name Enemy

var xp: float = 50.0

var player: Player

func scale_enemy(factor: float):
	health_component.scale_max_hp(factor)
	attack_component.multiplier *= factor
	xp **= factor

#func _process(delta: float) -> void:
	#super._process(delta)
	#rotation = player.rotation

func _on_health_component_hp_depleted() -> void:
	queue_free()
