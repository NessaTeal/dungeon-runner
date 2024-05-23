extends Node

var perk_points: int = 0

var _perks_base_array = [
	{
		'name': 'Acceleration',
		'state': false,
		'script': preload("Agility/acceleration.gd"),
		'unlocks': ['SpeedImpact'],
		'locks': ['Tenacity']
	},
	{
		'name': 'MoveSpeed',
		'state': false,
		'script': preload("Agility/move_speed.gd"),
		'unlocks': ['Acceleration', 'Tenacity'],
		'locks': []
	},
	{
		'name': 'SpeedImpact',
		'state': false,
		'script': preload("Agility/speed_impact.gd"),
		'unlocks': [],
		'locks': []
	},
	{
		'name': 'SpeedToDamage',
		'state': false,
		'script': preload("Agility/speed_to_damage.gd"),
		'unlocks': [],
		'locks': []
	},
	{
		'name': 'Tenacity',
		'state': false,
		'script': preload("Agility/tenacity.gd"),
		'unlocks': ['SpeedToDamage'],
		'locks': ['Acceleration']
	},
	{
		'name': 'Toughness',
		'state': false,
		'script': preload("Vitality/toughness.gd"),
		'unlocks': ['Immolate', 'Retaliate'],
		'locks': []
	},
	{
		'name': 'Immolate',
		'state': false,
		'script': preload("Vitality/immolate.gd"),
		'unlocks': ['ImmolateStorage'],
		'locks': ['Retaliate']
	},
	{
		'name': 'ImmolateStorage',
		'state': false,
		'script': preload("Vitality/immolate_storage.gd"),
		'unlocks': [],
		'locks': []
	},
	{
		'name': 'Retaliate',
		'state': false,
		'script': preload("Vitality/retaliate.gd"),
		'unlocks': ['HPRegen'],
		'locks': ['Immolate']
	},
	{
		'name': 'HPRegen',
		'state': false,
		'script': preload("Vitality/hp_regen.gd"),
		'unlocks': [],
		'locks': []
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
