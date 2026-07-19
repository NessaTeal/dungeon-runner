class_name Perks

static func upgrade(perk: Perk) -> void:
	perk._level += 1
	perk.script_instance?.on_upgrade()
	
	if Meta.save_data.perk_levels.has(perk.resource_path):
		Meta.save_data.perk_levels[perk.resource_path] += 1
	else:
		Meta.save_data.perk_levels[perk.resource_path] = 1
		
static func downgrade(perk: Perk) -> void:
	perk._level -= 1
	perk.script_instance?.on_downgrade()
		
	perk.get_perk_cost().refund()
	
	if Meta.save_data.perk_levels[perk.resource_path] == 1:
		Meta.save_data.perk_levels.erase(perk.resource_path)
	else:
		Meta.save_data.perk_levels[perk.resource_path] -= 1

static func can_buy_elemental() -> bool:
	return Meta.save_data.get_elemental_perks_count() < Meta.save_data.elemental_limit
