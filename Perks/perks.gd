class_name Perks

static func upgrade(perk: Perk) -> void:
	perk._level += 1
	perk.script_instance?.on_upgrade()
	
	if SaveData.instance.perk_levels.has(perk.resource_path):
		SaveData.instance.perk_levels[perk.resource_path] += 1
	else:
		SaveData.instance.perk_levels[perk.resource_path] = 1
		
static func downgrade(perk: Perk) -> void:
	perk._level -= 1
	perk.script_instance?.on_downgrade()
		
	perk.get_perk_cost().refund()
	
	if SaveData.instance.perk_levels[perk.resource_path] == 1:
		SaveData.instance.perk_levels.erase(perk.resource_path)
	else:
		SaveData.instance.perk_levels[perk.resource_path] -= 1

static func can_buy_elemental() -> bool:
	return SaveData.instance.get_elemental_perks_count() < SaveData.instance.elemental_limit

static func get_elemental_limit() -> int:
	return SaveData.instance.elemental_limit
