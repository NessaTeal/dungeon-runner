extends PlayerAffix
class_name DressageTurnRateAffix

func apply() -> void:
	player.direction_component.turn_rate += get_value()
