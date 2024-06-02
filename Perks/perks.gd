extends Node

var perk_points: int = 0

var _perks_base_array = [
	{
		'name': 'Acceleration',
		'state': false,
		'script': preload("Agility/acceleration.gd"),
		'unlocks': ['SpeedImpact'],
		'locks': ['Tenacity'],
		'description': tr("ACCELERATION_DESCRIPTION")
	},
	{
		'name': 'MoveSpeed',
		'state': false,
		'script': preload("Agility/move_speed.gd"),
		'unlocks': ['Acceleration', 'Tenacity'],
		'locks': [],
		'description': tr("MOVE_SPEED_DESCRIPTION")
	},
	{
		'name': 'SpeedImpact',
		'state': false,
		'script': preload("Agility/speed_impact.gd"),
		'unlocks': [],
		'locks': [],
		'description': tr("SPEED_IMPACT_DESCRIPTION")
	},
	{
		'name': 'SpeedToDamage',
		'state': false,
		'script': preload("Agility/speed_to_damage.gd"),
		'unlocks': [],
		'locks': [],
		'description': tr("SPEED_TO_DAMAGE_DESCRIPTION")
	},
	{
		'name': 'Tenacity',
		'state': false,
		'script': preload("Agility/tenacity.gd"),
		'unlocks': ['SpeedToDamage'],
		'locks': ['Acceleration'],
		'description': tr("TENACITY_DESCRIPTION")
	},
	{
		'name': 'Toughness',
		'state': false,
		'script': preload("Vitality/toughness.gd"),
		'unlocks': ['Immolate', 'Retaliate'],
		'locks': [],
		'description': tr("TOUGHNESS_DESCRIPTION")
	},
	{
		'name': 'Immolate',
		'state': false,
		'script': preload("Vitality/immolate.gd"),
		'unlocks': ['ImmolateStorage'],
		'locks': ['Retaliate'],
		'description': tr("IMMOLATE_DESCRIPTION")
	},
	{
		'name': 'ImmolateStorage',
		'state': false,
		'script': preload("Vitality/immolate_storage.gd"),
		'unlocks': [],
		'locks': [],
		'description': tr("IMMOLATE_STORAGE_DESCRIPTION")
	},
	{
		'name': 'Retaliate',
		'state': false,
		'script': preload("Vitality/retaliate.gd"),
		'unlocks': ['HPRegen'],
		'locks': ['Immolate'],
		'description': tr("RETALIATE_DESCRIPTION")
	},
	{
		'name': 'HPRegen',
		'state': false,
		'script': preload("Vitality/hp_regen.gd"),
		'unlocks': [],
		'locks': [],
		'description': tr("HP_REGEN_DESCRIPTION")
	},
]

var active_perks = _perks_base_array.reduce(_reduce_perks, {})

func _reduce_perks(acc, val):
	var unlocked_by = []
	var locked_by = []
	for perk in _perks_base_array:
		for unlock: String in perk.unlocks:
			if val.name == unlock:
				unlocked_by.append(perk)
		
		for lock: String in perk.locks:
			if val.name == lock:
				locked_by.append(perk)

	val['unlocked_by'] = unlocked_by
	val['locked_by'] = locked_by
	acc[val.name] = val
	return acc
