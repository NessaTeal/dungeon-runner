class_name Perks

static var affixes_changed = Utils.make_signal(Perks, "affixes_changed")

static func upgrade(perk: Perk) -> void:
	perk._level += 1
	
	if SaveData.instance.perk_levels.has(perk.resource_path):
		SaveData.instance.perk_levels[perk.resource_path] += 1
	else:
		SaveData.instance.perk_levels[perk.resource_path] = 1
	
	affixes_changed.emit()

static func downgrade(perk: Perk) -> void:
	perk._level -= 1
	
	perk.get_perk_cost().refund()
	
	if SaveData.instance.perk_levels[perk.resource_path] == 1:
		SaveData.instance.perk_levels.erase(perk.resource_path)
	else:
		SaveData.instance.perk_levels[perk.resource_path] -= 1
	
	affixes_changed.emit()

static func can_buy_elemental() -> bool:
	return get_elemental_perks_count() < get_elemental_limit()

static func get_elemental_limit() -> int:
	return roundi(get_total_affixes_power(ElementalLimitAffix)) + 1

static func get_elemental_perks_count() -> int:
	return get_all_perks().filter(func(perk): return perk.elemental).size()

static func get_all_perks() -> Array[Perk]:
	return SaveData.instance.perk_levels.keys().map(func(key): return load(key))

static func get_all_affixes() -> Array[BaseAffix]:
	var affixes: Array[BaseAffix] = []
	for perk in get_all_perks():
		affixes.append_array(perk.affixes)
	return affixes

static func get_all_affixes_of_class(affix_class: GDScript[BaseAffix]) -> Array[BaseAffix]:
	return get_all_affixes().filter(func(affix): return is_instance_of(affix, affix_class))
	
static func get_total_affixes_power(affix_class: GDScript[BaseAffix]) -> float:
	return get_all_affixes_of_class(affix_class).reduce(func(total: float, affix): return total + affix.get_value(), 0.0)
	
static func get_total_affixes_poweri(affix_class: GDScript[BaseAffix]) -> int:
	return roundi(get_total_affixes_power(affix_class))
