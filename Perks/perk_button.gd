extends Control
class_name PerkButton

@export var perk_resource: Perk

var unlocks: Array[PerkButton] = []
var locks: Array[PerkButton] = []

@export_category("Internals")
@export var button: Button
@export var icon_component: TextureRect

var hovered = false
var pressed = false

func _ready() -> void:
	icon_component.texture = perk_resource.icon
	update_modulate()

func recalculate() -> void:
	var button_should_be_enabled = perk_resource.can_be_upgraded() or perk_resource.can_be_downgraded()
	change_button_disabled(not button_should_be_enabled)

func _on_mouse_entered() -> void:
	calculate_tooltip()
	hovered = true
	update_modulate()
	
func calculate_tooltip() -> void:
	HoverBox.reset()
	HoverBox.show_perk(perk_resource);
	HoverBox.visible = true

func _on_mouse_exited() -> void:
	HoverBox.visible = false
	hovered = false
	update_modulate()

func update_modulate():
	if perk_resource.is_maxed():
		button.self_modulate = Color.GOLDENROD
	elif perk_resource._level > 0:
		button.self_modulate = Color.GREEN
	else:
		button.self_modulate = Color.WHITE
	
	var current_colour = Color(1,1,1)
	
	var button_should_be_grayed_out = not (perk_resource.can_be_upgraded() or perk_resource.is_maxed()) or button.disabled
	
	if button_should_be_grayed_out:
		current_colour = Color(0.5,0.5,0.5)
		if button.disabled:
			modulate = current_colour
			return

	if hovered:
		current_colour = current_colour.darkened(0.1)
		
	if pressed:
		current_colour = current_colour.darkened(0.05)
	
	modulate = current_colour

func _on_button_pressed(mouse_button_index: MouseButton) -> void:
	var something_happened = false
	if mouse_button_index == MOUSE_BUTTON_LEFT and perk_resource.get_perk_cost().can_afford() and perk_resource._level != perk_resource.max_level:
		perk_resource.get_perk_cost().pay()
		
		Perks.upgrade(perk_resource)
		something_happened = true
	elif mouse_button_index == MOUSE_BUTTON_RIGHT and perk_resource.can_be_downgraded():
		Perks.downgrade(perk_resource)
		something_happened = true
			
	if something_happened:
		calculate_tooltip()
		update_modulate()
		
		if not Meta.debug:
			SaveData.save_game()

func change_button_disabled(disabled: bool):
	button.disabled = disabled
	update_modulate()

func _on_button_button_down() -> void:
	pressed = true
	update_modulate()

func _on_button_button_up() -> void:
	pressed = false
	update_modulate()
