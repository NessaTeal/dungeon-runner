extends PlayerAffix
class_name TenacityAffix

func get_scaled_power() -> float:
	return get_total_power() / 200.0

func apply() -> void:
	player.speed_component.fight_speed += get_value()
