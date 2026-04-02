@tool
extends Control
class_name PerkButton

@export var perk_resource: Perk

var unlocks: Array[PerkButton] = []
var locks: Array[PerkButton] = []
var unlocked_by: Array[PerkButton] = []
var locked_by: Array[PerkButton] = []

@export_category("Internals")
@export var button: Button
@export var label: Label
@export var icon_component: TextureRect

const halo_normal := preload("res://Textures/ui_icon_empty_white.png")
const halo_golden := preload("res://Textures/ui_icon_empty_orange.png")

func _ready() -> void:
	icon_component.texture = perk_resource.icon
	label.text = perk_resource.perk_name
	var perk_active := perk_resource._level
	
	if perk_active:
		button.icon = halo_golden
	if perk_resource._level == perk_resource.max_level:
		button.disabled = true

func recalculate() -> void:
	visible = unlocked_by.all(func(lock: PerkButton) -> bool: return lock.perk_resource._level > 0)
	
	if locked_by.any(func(lock: PerkButton) -> bool: return lock.perk_resource._level > 0):
		button.disabled = true

	if not perk_resource.get_perk_cost().can_afford():
		button.disabled = true

func _on_mouse_entered() -> void:
	calculate_tooltip()
	
func calculate_tooltip() -> void:
	HoverBox.reset()
	HoverBox.show_perk(perk_resource);
	HoverBox.visible = true

func _on_mouse_exited() -> void:
	HoverBox.visible = false

func _on_button_button_up() -> void:
	if perk_resource.get_perk_cost().can_afford():
		perk_resource.get_perk_cost().pay()
		button.icon = halo_golden
		perk_resource.increase_level()
		if perk_resource._level == perk_resource.max_level:
			button.disabled = true
		Perks.active_perks[perk_resource.perk_name] = perk_resource
		calculate_tooltip()
