extends Object
class_name Perks

static func upgrade(perk: Perk) -> void:
	perk._level += 1
	if Meta.save_data.perk_levels.has(perk.resource_path):
		Meta.save_data.perk_levels[perk.resource_path] += 1
	else:
		Meta.save_data.perk_levels[perk.resource_path] = 1
