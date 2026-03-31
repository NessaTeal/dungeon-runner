extends PlayerAffix
class_name AttackPowerAffix

func get_scaled_power() -> float:
	return get_power() / 10.0

func apply() -> void:
	player.attack_component.damage += get_value()
