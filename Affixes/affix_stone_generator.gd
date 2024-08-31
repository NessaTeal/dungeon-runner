extends Object

var stone_rarities = [[60, 1, 50, 85], [30, 2, 60, 90], [7, 3, 70, 95], [3, 4, 75, 100]]

static var all_affixes = [
	#preload("res://Affixes/Power/attack_power.gd"),
	#preload("res://Affixes/Power/attack_speed.gd"),
	#preload("res://Affixes/Agility/trample.gd"),
	#preload("res://Affixes/Agility/acceleration.gd"),
	#preload("res://Affixes/Agility/move_speed.gd"),
	#preload("res://Affixes/Agility/slingshot.gd")
	#preload("res://Affixes/Agility/tenacity.gd"),
	#preload("res://Affixes/Vitality/hp_regen.gd"),
	#preload("res://Affixes/Vitality/toughness.gd")
	preload("res://Affixes/Vitality/immolation.gd")
]

var stone_script = preload("res://Affixes/stone.gd")

func generate_stone():
	var roll = randi() % 100
	
	var chosen_rarity
	
	for rarity in stone_rarities:
		if roll < rarity[0]:
			chosen_rarity = rarity
			break
		else:
			roll -= rarity[0]
	
	var stone = stone_script.new()
	
	for i in range(chosen_rarity[1]):
		var affix = all_affixes[randi() % all_affixes.size()].new()
		affix.power = (randi() % (chosen_rarity[3] - chosen_rarity[2])) + chosen_rarity[2]
		stone.affixes.push_back(affix)
	
	return stone
