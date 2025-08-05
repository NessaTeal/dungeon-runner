extends PlayerAffix
class_name ToughnessAffix

func get_value() -> float:
	return power * 2

func apply() -> void:
	player.health_component.max_hp += get_value()
