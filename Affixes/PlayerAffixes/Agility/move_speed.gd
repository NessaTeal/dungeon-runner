extends PlayerAffix
class_name MoveSpeedAffix

func get_scaled_power() -> float:
	return get_total_power() / 10.0

func apply() -> void:
	player.speed_component.current_speed += get_value()
