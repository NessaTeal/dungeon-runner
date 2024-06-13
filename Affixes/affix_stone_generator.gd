extends Node

var stone_rarities = [[60, 1, 50, 85], [30, 2, 60, 90], [7, 3, 70, 95], [3, 4, 75, 100]]

var all_affixes = [
	preload("res://Affixes/Agility/acceleration.gd"),
	preload("res://Affixes/Agility/move_speed.gd"),
	preload("res://Affixes/Agility/speed_impact.gd"),
	preload("res://Affixes/Agility/speed_to_damage.gd"),
	preload("res://Affixes/Agility/tenacity.gd"),
	preload("res://Affixes/Vitality/hp_regen.gd"),
	preload("res://Affixes/Vitality/toughness.gd")
]

func generate_stone():
	var roll = randi() % 100
	
	var chosen_rarity
	
	for rarity in stone_rarities:
		if roll < rarity[0]:
			chosen_rarity = rarity
			break
		else:
			roll -= rarity[0]
	
	var stone = Node.new()
	
	for i in range(chosen_rarity[1]):
		var affix = all_affixes[randi() % all_affixes.size()].new()
		affix.power = (randi() % (chosen_rarity[3] - chosen_rarity[2])) + chosen_rarity[2]
		stone.add_child(affix)
	
	return stone
