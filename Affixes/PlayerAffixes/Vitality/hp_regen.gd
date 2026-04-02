extends PlayerAffix
class_name HPRegenAffix

func get_scaled_power() -> float:
	return get_total_power() / 25.0

func apply() -> void:
	player.health_component.hp_regen += get_value()
