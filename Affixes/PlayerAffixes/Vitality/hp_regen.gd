extends PlayerAffix
class_name HPRegenAffix

func get_value() -> float:
	return power / 25.0

func apply() -> void:
	player.health_component.hp_regen += get_value()
