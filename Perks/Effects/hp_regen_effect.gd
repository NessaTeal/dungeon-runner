extends Node

var unit: BaseUnit

func _ready():
	unit = get_parent()

func _process(delta):
	var regened_hp = unit.hp_regen * delta

	if unit is Player:
		regened_hp += unit.game_state.player_hp_regen_from_missing_hp * (unit.max_hp - unit.hp) * delta

	unit.hp = min(unit.hp + regened_hp, unit.max_hp)

	unit.update_hp()
