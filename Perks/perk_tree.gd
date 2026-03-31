extends Control
class_name PerkTree

@export var perk_buttons: GridContainer
@export var new_perk_buttons: HBoxContainer
@export var starting_perk: Perk

signal perks_changed

var perk_buttons_a: Array[PerkButton] = []

func _ready() -> void:
	#var perks: Array[Perk] = [starting_perk]
	var box := HBoxContainer.new()
	calculate_perks([starting_perk], box)
	new_perk_buttons.add_child(box)
	for button in perk_buttons_a:
		button.recalculate()

func calculate_perks(perks: Array[Perk], container: HBoxContainer, parent_button: PerkButton = null) -> Array[PerkButton]:
	#var new_perks: Array[Perk] = []
	var vertical_box := VBoxContainer.new()
	container.add_child(vertical_box)
	var child_buttons: Array[PerkButton] = []
	for perk in perks:
		var perk_button: PerkButton = preload("res://Perks/perk_button.tscn").instantiate() as PerkButton
		Utils.handled_connect(perk_button.button.button_up, func() -> void:
			for button in perk_buttons_a:
				button.recalculate()
			perks_changed.emit())
		perk_buttons_a.push_back(perk_button)
		child_buttons.push_back(perk_button)
		if parent_button:
			perk_button.unlocked_by.push_back(parent_button)
		else:
			perk_button.visible = true
		
		perk_button.perk_resource = perk
		vertical_box.add_child(perk_button)
		if perk.unlocks:
			#var horizontal_box := HBoxContainer.new()
			#horizontal_box.add_child(vertical_box)
			var children := calculate_perks(perk.unlocks, container, perk_button)
			perk_button.unlocks = children
	
	return child_buttons
		#for perk_unlock in perk.unlocks:
			#new_perks.push_back(perk_unlock)
	#perks = new_perks
