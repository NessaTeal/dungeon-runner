extends PlayerAffix
class_name DressageTurnRateAffix

func apply() -> void:
	var oldRate := player.direction_component.turn_rate
	var newRate := oldRate + get_value()
	player.direction_component.turn_rate += get_value()
