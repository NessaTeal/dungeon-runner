@tool
extends Control
class_name PerkTree

@export var perk_buttons: HBoxContainer
@export var starting_perk: Perk

signal perks_changed

var all_perk_buttons: Array[PerkButton] = []

func _ready() -> void:
	var box := HBoxContainer.new()
	assert(len(calculate_perks([starting_perk], box)) == 1, "More than 1 root perk found")
	perk_buttons.add_child(box)
	
	if not Engine.is_editor_hint():
		for button in all_perk_buttons :
			button.recalculate()
	

func calculate_perks(perks: Array[Perk], container: HBoxContainer, parent_button: PerkButton = null) -> Array[PerkButton]:
	var vertical_box := VBoxContainer.new()
	container.add_child(vertical_box)
	
	var child_buttons: Array[PerkButton] = []
	
	for perk in perks:
		var perk_button: PerkButton = preload("res://Perks/perk_button.tscn").instantiate() as PerkButton
		Utils.handled_connect(perk_button.button.button_up, func() -> void:
			for button in all_perk_buttons:
				button.recalculate()
			perks_changed.emit())
		all_perk_buttons.push_back(perk_button)
		child_buttons.push_back(perk_button)
		if parent_button:
			perk_button.unlocked_by.push_back(parent_button)
		else:
			perk_button.visible = true
		
		perk_button.perk_resource = perk
		vertical_box.add_child(perk_button)
		if perk.unlocks:
			var children := calculate_perks(perk.unlocks, container, perk_button)
			perk_button.unlocks = children
	
	return child_buttons
