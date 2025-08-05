extends BaseUnit
class_name Enemy

var xp := 50.0

var player: Player

func scale_enemy(factor: float) -> void:
	health_component.scale_max_hp(factor)
	attack_component.multiplier *= factor
	xp **= factor
