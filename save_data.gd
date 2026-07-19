#extends Resource
class_name SaveData

const save_file_path := "user://save.json"

@export var collected_resources_data: Array = []
@export var perk_levels: Dictionary = {}
@export var elemental_limit: int = 1

func get_all_perks() -> Array[Perk]:
	return perk_levels.keys().map(func(key): return load(key))

func get_elemental_perks_count() -> int:
	var result := 0
	for perk_path in perk_levels.keys():
		if (load(perk_path) as Perk).elemental:
			result += 1
	return result

func _init() -> void:
	collected_resources_data.resize(Collectible.Type.Count)

func _to_string() -> String:
	var string =  "<SaveData"
	for prop in ObjectSerializer.get_serializable_properties(self):
		string += " %s=%s" % [prop.name, get(prop.name)]
	string += ">"
	return string

static func save_game() -> void:
	if FileAccess.file_exists(save_file_path):
		var copy_error = DirAccess.copy_absolute(save_file_path, save_file_path + '.backup')
		if copy_error != OK:
			push_warning("Failed to make a backup of a save file ", copy_error)
	var save_file := FileAccess.open(save_file_path, FileAccess.WRITE)
	var json_string := JSON.stringify(ObjectSerializer.serialize(instance), "\t")
	save_file.store_string(json_string)
	
static func load_game() -> void:
	if FileAccess.file_exists(save_file_path):
		var save_file = FileAccess.open(save_file_path, FileAccess.READ)
		var json_string = save_file.get_as_text()
		var json = JSON.new()
		
		var parse_result := json.parse(json_string)
		if parse_result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		
		instance = ObjectSerializer.deserialize(json.data)

static func reset_game() -> void:
	if FileAccess.file_exists(save_file_path):
		DirAccess.remove_absolute(save_file_path)
		
	instance = new()
	
	# Resetting resources levels to 0
	# Assumes single root perk, which probably won't be true forever
	var perks: Array[Perk] = [preload("res://Perks/Milestone/honsing_around.tres")]
	while not perks.is_empty():
		var perk = perks.pop_back()
		perk._level = 0
		perks.append_array(perk.unlocks)

static var instance = new()
