extends PlayerAffix
class_name AccelerationAffix

func get_scaled_power() -> float:
	return get_total_power() / 10.0

func apply() -> void:
	player.speed_component.acceleration += get_value()
