extends PlayerAffix
class_name TenacityAffix

func get_value() -> float:
	return power / 200.0

func apply() -> void:
	player.speed_component.fight_speed += get_value()
