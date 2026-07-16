extends Control
class_name PerkButton

@export var perk_resource: Perk

var unlocks: Array[PerkButton] = []
var locks: Array[PerkButton] = []

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
	if perk_resource._level == perk_resource.max_level:
		button.disabled = true
	elif not perk_resource.get_perk_cost().can_afford():
		button.disabled = true
	elif perk_resource.elemental and not Perks.can_buy_elemental():
		button.disabled = true
	else:
		button.disabled = false

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
		
		Perks.upgrade(perk_resource)
		
		if perk_resource._level == perk_resource.max_level:
			button.disabled = true
		
		calculate_tooltip()
