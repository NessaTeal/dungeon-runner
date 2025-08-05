extends PlayerAffix
class_name ImmolationAffix

func get_value() -> float:
	return power / 20.0

func apply() -> void:
	player.immolation_component.immolation_damage += get_value()
