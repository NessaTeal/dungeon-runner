extends PlayerAffix
class_name AttackSpeedAffix

func get_scaled_power() -> float:
	return get_power() / 5.0

func apply() -> void:
	player.attack_component.affix_attack_speed += get_value()
