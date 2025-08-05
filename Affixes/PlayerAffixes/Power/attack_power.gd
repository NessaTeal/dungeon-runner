extends PlayerAffix
class_name AttackPowerAffix

func get_value() -> float:
	return power / 10.0

func apply() -> void:
	player.attack_component.damage += get_value()
