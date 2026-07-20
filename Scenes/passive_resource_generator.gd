extends Node

var apples_per_period = 0

func update_values():
	pass

func _on_apple_timer_timeout() -> void:
	if apples_per_period > 0:
		Collectible.apples += apples_per_period
