extends Node

class_name GameState

var player_level: int = 1

# Vitality
var immolate: float = 0
var immolate_storage: float = 0
var retaliate: float = 0

var base_encounter_chance: float = 1.0
var encounter_chance: float = 1.0
var encounter_chance_increase: float = 1.0/10

var fight_xp: float = 0

func _ready():
	for perk_key in Perks.active_perks:
		if Perks.active_perks[perk_key].state:
			Perks.active_perks[perk_key].script.apply(self)
