extends Node

class_name GameState

var player_level: int = 1
var player_hp: float = 200
var player_hp_regen: float = 10
var current_move_speed: float = 10
var modified_move_speed: float = 10

# Agility
var move_speed_from_acceleration: float = 0
var acceleration: float = 0
var speed_during_fight: float = 0
var speed_to_damage_multiplier: float = 0
var speed_impact: float = 0
# Vitality
var player_hp_regen_from_missing_hp: float = 0
var immolate: float = 0
var immolate_storage: float = 0
var retaliate: float = 0

var fighting: bool = false
var distance: float = 0

var base_encounter_chance: float = 1.0/10
var encounter_chance: float = 1.0/10
var encounter_chance_increase: float = 1.0/10

var fight_xp: float = 0

func _ready():
	for perk_key in Perks.active_perks:
		if Perks.active_perks[perk_key].state:
			Perks.active_perks[perk_key].script.apply(self)
	
	for stone in Inventory.slots.filter(func(slot): return slot.item).map(func(slot): return slot.item.stone):
		for affix in stone.get_children():
			affix.apply(self)
