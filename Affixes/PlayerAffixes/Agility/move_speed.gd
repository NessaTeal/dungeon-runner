extends PlayerAffix
class_name MoveSpeedAffix

func get_value() -> float:
	return power / 10.0

func apply() -> void:
	player.speed_component.current_speed += get_value()
