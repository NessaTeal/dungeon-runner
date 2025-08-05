extends PlayerAffix
class_name AccelerationAffix

func get_value() -> float:
	return power / 10.0

func apply() -> void:
	player.speed_component.acceleration += get_value()
