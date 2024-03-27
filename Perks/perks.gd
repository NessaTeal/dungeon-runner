extends Node

var perk_points: int = 0

var active_perks = {
	'Acceleration': {
		'state': false,
		'script': preload("Agility/acceleration.gd")
	},
	'MoveSpeed': {
		'state': false,
		'script': preload("Agility/move_speed.gd")
	},
	'SpeedImpact': {
		'state': false,
		'script': preload("Agility/speed_impact.gd")
	},
	'SpeedToDamage': {
		'state': false,
		'script': preload("Agility/speed_to_damage.gd")
	},
	'Tenacity': {
		'state': false,
		'script': preload("Agility/tenacity.gd")
	},
}
