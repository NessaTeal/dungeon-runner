extends Node

var apple_healing = Perks.get_total_affixes_power(AppleHealingAffix)
var apples_per_apples = 1 + Perks.get_total_affixes_poweri(ExtraApplesAffix)
var apple_chance = 0.005 + Perks.get_total_affixes_power(AppleChanceAffix) / 100.0
var apple_cluster_chance = Perks.get_total_affixes_power(FruitfulHarvestAffix)

var grit_per_minute = Perks.get_total_affixes_power(GritGainAffix)

var souls_per_enemy = 1
var spawn_chance = Perks.get_total_affixes_power(SpawnChanceAffix)

func _ready():
	Perks.affixes_changed.connect(_reset)

func _reset() -> void:
	var script = preload("res://Perks/current_run_state.gd")
	set_script(null)
	set_script(script)
