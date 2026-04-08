extends Node

var player_level: int = 1

var current_xp: float = 0
var required_xp: float = 100

func set_xp_for_next_level() -> void:
	required_xp = get_xp_for_level(player_level)
	
func get_xp_for_level(level: int) -> int:
	return 100 * (level ** 2)

# All collected stuff

var collected_resources := PerkCost.new()
const collected_resources_path := "user://collected_resources.json"

func save_collected_resources() -> void:
	var save_file := FileAccess.open(collected_resources_path, FileAccess.WRITE)
	var data := collected_resources.get_save_data()
	var json_string := JSON.stringify(data, "\t")
	save_file.store_string(json_string)
	
func load_collected_resources() -> void:
	if FileAccess.file_exists(collected_resources_path):
		var save_file := FileAccess.open(collected_resources_path, FileAccess.READ)
		var json_string := save_file.get_as_text()
		var json := JSON.new()
			
		var parse_result := json.parse(json_string)
		if parse_result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		
		for json_key in json.data.keys() as Array[String]:
			var json_value = json.data[json_key]
			collected_resources.set(json_key, json_value)
	
# Apple params
var apple_heal := 0.0
var apple_spawn_chance := 0.005

func _ready() -> void:
	load_collected_resources()
