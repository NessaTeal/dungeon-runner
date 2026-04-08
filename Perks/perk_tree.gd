@tool
extends Control
class_name PerkTree

@export var perk_buttons: HBoxContainer
@export var starting_perk: Perk

signal perks_changed

var all_perk_buttons: Array[PerkButton] = []
var all_perk_boxes: Array[PerkBox] = []

const saved_perk_path := "user://perks.json"

var perks_saved_level: Dictionary[String, int] = {}

func _ready() -> void:
	load_perks()
	
	var perk_box_scene := preload("res://Perks/perk_box.tscn")
	var first_perk_box := perk_box_scene.instantiate() as PerkBox
	var first_perk := preload("res://Perks/Vitality/max_energy_0.tres")
	first_perk_box.perk = first_perk
	if perks_saved_level.has(first_perk.perk_name):
			first_perk._level = perks_saved_level[first_perk.perk_name]
	add_child(first_perk_box)
	
	var perk_boxes_to_process := [first_perk_box]
	
	while len(perk_boxes_to_process):
		var perk_box: PerkBox = perk_boxes_to_process.pop_back()
		var perk := perk_box.perk
		
		
		Utils.handled_connect(perk_box.perk_button.button.button_up, recalculate_perks.bind(perk.perk_name))
		var children_directions = PerkBox.DIRECTION.values().filter(func(value: int) -> bool: return value != PerkBox.OPPOSITE_DIRECTIONS[perk_box.direction])
		assert(len(perk.unlocks) <= len(children_directions), "Trying to add more children than allowed")
		
		for child_perk_index in len(perk.unlocks):
			var child_perk := perk.unlocks[child_perk_index]
			var child_direction := children_directions[child_perk_index] as PerkBox.DIRECTION
			var child_perk_box := perk_box_scene.instantiate() as PerkBox
			child_perk_box.perk = child_perk
			child_perk_box.direction = child_direction
			child_perk_box.distance = perk_box.distance + 1
			child_perk_box.parent = perk_box
			child_perk_box.name = child_perk.perk_name
			all_perk_boxes.push_back(child_perk_box)
			perk_box.children_boxes.push_back(child_perk_box)
			perk_boxes_to_process.push_front(child_perk_box)
			if perks_saved_level.has(child_perk.perk_name):
				child_perk._level = perks_saved_level[child_perk.perk_name]
			add_child(child_perk_box)
			child_perk_box.perk_button.unlocked_by.push_back(perk_box.perk_button)
			
	first_perk_box.update_position()
	
	for perk_box in all_perk_boxes:
		perk_box.visible = perk_box.perk_button.unlocked_by.all(func(lock: PerkButton) -> bool: return lock.perk_resource._level > 0)
	perks_changed.emit()
	
func recalculate_perks(perk_name: String) -> void:
	for perk_box in all_perk_boxes:
		perk_box.visible = perk_box.perk_button.unlocked_by.all(func(lock: PerkButton) -> bool: return lock.perk_resource._level > 0)
	perks_changed.emit()
	
	if perks_saved_level.has(perk_name):
		perks_saved_level[perk_name] += 1
	else:
		perks_saved_level[perk_name] = 1
	save_perks()

func save_perks() -> void:
	var save_file := FileAccess.open(saved_perk_path, FileAccess.WRITE)
	var json_string := JSON.stringify(perks_saved_level, "\t")
	save_file.store_string(json_string)

func load_perks() -> void:
	if FileAccess.file_exists(saved_perk_path):
		var save_file := FileAccess.open(saved_perk_path, FileAccess.READ)
		var json_string := save_file.get_as_text()
		var json := JSON.new()
			
		var parse_result := json.parse(json_string)
		if parse_result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return
		
		for json_key in json.data.keys() as Array[String]:
			var json_value = json.data[json_key] as int
			perks_saved_level[json_key] = json_value
