extends Object

@export var stone_rarities: Array[StoneRarity]
#[[60, 1, 50, 85], [30, 2, 60, 90], [7, 3, 70, 95], [3, 4, 75, 100]]

@export var all_affixes: Array[BaseAffix] = []

func generate_stone() -> Stone:
	var roll := randf() * 100
	var chosen_rarity: StoneRarity
	
	for rarity in stone_rarities:
		if roll < rarity.chance:
			chosen_rarity = rarity
			break
		else:
			roll -= rarity.chance
	
	var stone := Stone.new()
	
	for i in range(chosen_rarity.affix_count):
		#var affix = a.new()
		var affix := all_affixes[randi() % all_affixes.size()].duplicate() as BaseAffix
		affix.power = (randf() * (chosen_rarity.maximum_power - chosen_rarity.minimum_power)) + chosen_rarity.minimum_power
		stone.affixes.push_back(affix)
	
	return stone
