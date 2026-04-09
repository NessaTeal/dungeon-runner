extends Node

var player_level: int = 1

var current_xp: float = 0
var required_xp: float = 100

func set_xp_for_next_level() -> void:
	required_xp = get_xp_for_level(player_level)
	
func get_xp_for_level(level: int) -> int:
	return 100 * (level ** 2)

## Collectibles
# All collected stuff

# Apple params
var apple_heal := 0.0
var apple_spawn_chance := 0.005

# Saving
var save_data = SaveData.new()

const save_file_path := "user://save.json"

func save_game() -> void:
	if FileAccess.file_exists(save_file_path):
		var copy_error = DirAccess.copy_absolute(save_file_path, save_file_path + '.backup')
		if copy_error != OK:
			push_warning("Failed to make a backup of a save file ", copy_error)
	var save_file := FileAccess.open(save_file_path, FileAccess.WRITE)
	var json_string := JSON.stringify(save_data.serialize(), "\t")
	save_file.store_string(json_string)
	
func load_game() -> void:
	if FileAccess.file_exists(save_file_path):
		var save_file = FileAccess.open(save_file_path, FileAccess.READ)
		var json_string = save_file.get_as_text()
		var json = JSON.new()
		
		var parse_result := json.parse(json_string)
		if parse_result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		
		save_data.deserialize(json.data)

class SaveData:
	var collected_resources_data: Array[int] = []
	var perk_levels: Dictionary[String, int] = {}
	
	func _init() -> void:
		collected_resources_data.resize(Collectible.Type.Count)
		
	func serialize() -> Dictionary[String, Variant]:
		return {
			"collected_resources_data": collected_resources_data,
			"perk_levels": perk_levels
		}
		
	func deserialize(data: Dictionary) -> void:
		for resource_index in len(data['collected_resources_data']):
			collected_resources_data[resource_index] = data['collected_resources_data'][resource_index]
		
		for perk_path in data['perk_levels'].keys():
			perk_levels[perk_path] = data['perk_levels'][perk_path]

func _ready() -> void:
	load_game()
