extends BaseUnit

class_name Enemy

var xp: float = 50.0

func _ready():
	hp = 50

func scale_enemy(factor: float):
	max_hp *= factor
	hp *= factor
	hp_regen *= factor
	attack *= factor
	attack_speed *= factor
	xp **= factor
