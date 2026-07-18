extends Node

var apple_healing = 0.0
var apples_per_apples = 1
var apple_chance = 0.005
var apple_cluster_chance = 0.0

var grit_per_minute = 0.0

var souls_per_enemy = 1
var spawn_chance = 0.0

func reset() -> void:
	var script = preload("res://Perks/current_run_state.gd")
	set_script(null)
	set_script(script)
