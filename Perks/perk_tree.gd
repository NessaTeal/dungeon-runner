extends Control
class_name PerkTree

@export var starting_perk: Perk

signal perks_changed

var all_perk_boxes: Array[PerkBox] = []

func _ready() -> void:
	var perk_box_scene := preload("res://Perks/perk_box.tscn")
	var first_perk_box := perk_box_scene.instantiate() as PerkBox
	var first_perk := starting_perk
	first_perk_box.perk = first_perk
	
	if SaveData.instance.perk_levels.has(first_perk.resource_path):
		first_perk._level = SaveData.instance.perk_levels[first_perk.resource_path]
	add_child(first_perk_box)
	
	var perk_boxes_to_process := [first_perk_box]
	
	while len(perk_boxes_to_process):
		var perk_box: PerkBox = perk_boxes_to_process.pop_back()
		var perk := perk_box.perk
		
		all_perk_boxes.push_back(perk_box)
		
		Utils.handled_connect(perk_box.perk_button.button.button_up, recalculate_perks)
		Utils.handled_connect(perks_changed, perk_box.perk_button.recalculate)
		var children_directions = PerkBox.Direction.values()
			.filter(func(value): return value != PerkBox.OPPOSITE_DIRECTIONS[perk_box.direction]) \
			if perk_box.parent else PerkBox.Direction.values()
		assert(len(perk.unlocks) <= len(children_directions), "Trying to add more children than allowed")
		
		for child_perk_index in len(perk.unlocks):
			var child_perk := perk.unlocks[child_perk_index]
			var child_direction := children_directions[child_perk_index]
			var child_perk_box := perk_box_scene.instantiate() as PerkBox
			child_perk_box.perk = child_perk
			child_perk_box.direction = child_direction
			child_perk_box.distance = perk_box.distance + 1
			child_perk_box.parent = perk_box
			child_perk_box.name = child_perk.perk_name
			perk_box.children_boxes.push_back(child_perk_box)
			perk_boxes_to_process.push_front(child_perk_box)
			if SaveData.instance.perk_levels.has(child_perk.resource_path):
				child_perk._level = SaveData.instance.perk_levels[child_perk.resource_path]
			add_child(child_perk_box)
	
	for perk_box in all_perk_boxes:
		perk_box.perk.set_unlocks()
	
	first_perk_box.update_position()
	recalculate_perks()
	
func recalculate_perks() -> void:
	for perk_box in all_perk_boxes:
		var isVisible = perk_box.perk.unlocked_by.all(func(lock: Perk) -> bool: return lock._level > 0)
		if not Meta.debug:
			perk_box.visible = isVisible
		if is_visible:
			perk_box.perk_button.recalculate()
			perk_box.update_line_colour()
	
	perks_changed.emit()
