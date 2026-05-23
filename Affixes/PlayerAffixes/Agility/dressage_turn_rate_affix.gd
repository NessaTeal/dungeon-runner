extends PlayerAffix
class_name DressageTurnRateAffix

func apply() -> void:
	player.direction_component.turn_rate *= 1 + (get_value() / 100.0)
