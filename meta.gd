extends Node

var player_level: int = 1

var current_xp: float = 0
var required_xp: float = 100

func set_xp_for_next_level() -> void:
	required_xp = get_xp_for_level(player_level)
	
func get_xp_for_level(level: int) -> int:
	return 100 * (level ** 2)
