@tool
extends Control
class_name PerkButton

@export var icon: Texture
@export var perk_resource: Perk
@export var unlocks: Array[PerkButton] = []
@export var locks: Array[PerkButton] = []

var unlocked_by: Array[Perk] = []
var locked_by: Array[Perk] = []

@export_category("Internals")
@export var button: Button
@export var label: Label
@export var icon_component: TextureRect

const halo_normal := preload("res://Textures/ui_icon_empty_white.png")
const halo_golden := preload("res://Textures/ui_icon_empty_orange.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon_component.texture = icon
	label.text = perk_resource.perk_name
	var perk_active := perk_resource.enabled
	button.set_pressed_no_signal(perk_active)
	if perk_active:
		button.icon = halo_golden
	
	for unlock in unlocks:
		unlock.unlocked_by.push_back(perk_resource)
	for lock in locks:
		lock.locked_by.push_back(perk_resource)

func _on_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		# trying to enable perk and having enough points
		if Perks.perk_points > 0:
			button.icon = halo_golden
			Perks.perk_points -= 1
			perk_resource.enabled = true
			Perks.active_perks[perk_resource.perk_name] = perk_resource
		# if not enough perk points silently unpress button
		else:
			button.set_pressed_no_signal(false)
	# if perks are bought down the line unbuy them all
	#elif Perks.active_perks[perk_name].unlocks.filter(func(unlock: String) -> bool: return Perks.active_perks[unlock].enabled).is_empty():
		#button.icon = halo_normal
		#Perks.perk_points += 1
		#perk_resource.enabled = false
	else:
		for unlock in unlocks:
			if unlock.perk_resource.enabled:
				unlock.button.set_pressed_no_signal(false)
				unlock._on_button_toggled(false)
		button.icon = halo_normal
		Perks.perk_points += 1
		if not Perks.active_perks.erase(perk_resource.perk_name):
			printerr("Trying to remove perk which is not in the active dictionary")
		perk_resource.enabled = false
		#button.set_pressed_no_signal(true)
	# always recheck status of dependencies
	for unlock in unlocks:
		unlock.recalculate()
	for lock in locks:
		lock.recalculate()

func recalculate() -> void:
	if locked_by.any(func(lock: Perk) -> bool: return lock.enabled):
		button.disabled = true
	elif unlocked_by.all(func(lock: Perk) -> bool: return lock.enabled):
		button.disabled = false
	else:
		button.disabled = true
	
	#var unlock_perks = Perks.active_perks[perk_name].unlocked_by
	#var lock_perks = Perks.active_perks[perk_name].locked_by

	#button.disabled = !unlock_perks.all(func(perk: Perk) -> bool: return perk.enabled) or !lock_perks.all(func(perk: Perk) -> bool: return !perk.enabled)


func _on_mouse_entered() -> void:
	HoverBox.reset()
	HoverBox.add_line(perk_resource.description)
	HoverBox.visible = true

func _on_mouse_exited() -> void:
	HoverBox.visible = false
