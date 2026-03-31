extends PlayerAffix
class_name ToughnessAffix

func get_scaled_power() -> float:
	return get_power() * 2

func apply() -> void:
	player.health_component.add_max_hp(get_value())
