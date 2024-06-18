extends BaseUnit

class_name Enemy

var xp: float = 50.0

func scale_enemy(factor: float):
	health_component.scale_max_hp(factor)
	attack *= factor
	attack_speed *= factor
	xp **= factor
