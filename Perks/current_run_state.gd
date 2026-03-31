extends Node

var apple_healing := 0.0
var apples_per_apples := 1

func reset() -> void:
	var script := preload("res://Perks/current_run_state.gd")
	set_script(null)
	set_script(script)
