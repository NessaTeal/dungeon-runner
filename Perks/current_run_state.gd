extends Node

var apple_healing := 0.0
var apples_per_apples := 1
var apple_chance := 0.005

var grit_per_minute := 0.0

var fight_xp := 0
var spawn_chance := 0.0

func reset() -> void:
	var script := preload("res://Perks/current_run_state.gd")
	set_script(null)
	set_script(script)
