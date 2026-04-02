extends Node

var player_level: int = 1

var current_xp: float = 0
var required_xp: float = 100

func set_xp_for_next_level() -> void:
	required_xp = get_xp_for_level(player_level)
	
func get_xp_for_level(level: int) -> int:
	return 100 * (level ** 2)

# All collected stuff

const collected_resources_path := "usr://collected_resources.tres"
var collected_resources := load(collected_resources_path) as PerkCost if ResourceLoader.exists(collected_resources_path) else PerkCost.new()

# Apple params
var apple_heal := 0.0
var apple_spawn_chance := 0.005
