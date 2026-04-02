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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon_component.texture = perk_resource.icon
	label.text = perk_resource.perk_name
	var perk_active := perk_resource._level
	#button.set_pressed_no_signal(perk_active)
	if perk_active:
		button.icon = halo_golden
	if perk_resource._level == perk_resource.max_level:
		button.disabled = true
	#for unlock in perk_resource.unlocks:
		#unlock.unlocked_by.push_back(perk_resource)
	#for lock in perk_resource.locks:
		#lock.locked_by.push_back(perk_resource)

#func _on_button_toggled(button_pressed: bool) -> void:
	#if button_pressed:
		## trying to enable perk and having enough resources
		##var total_apples_cost := perk_resource.cost.apples + perk_resource.cost.apples_per_level * perk_resource.level
		#if perk_resource.get_perk_cost().can_afford():
			#Meta.apples -= get_cost()
			#button.icon = halo_golden
			#perk_resource.level += 1
			#if perk_resource.level == perk_resource.max_level:
				#button.disabled = true
			#Perks.active_perks[perk_resource.perk_name] = perk_resource
		## if not enough resources silently unpress button
		#else:
			#button.set_pressed_no_signal(false)
	# if perks are bought down the line unbuy them all
	#elif Perks.active_perks[perk_name].unlocks.filter(func(unlock: String) -> bool: return Perks.active_perks[unlock].enabled).is_empty():
		#button.icon = halo_normal
		#Perks.perk_points += 1
		#perk_resource.enabled = false
	#else:
		#for unlock in unlocks:
			#if unlock.perk_resource.level:
				#unlock.button.set_pressed_no_signal(false)
				#unlock._on_button_toggled(false)
		#button.icon = halo_normal
		#Perks.perk_points += 1
		#if not Perks.active_perks.erase(perk_resource.perk_name):
			#printerr("Trying to remove perk which is not in the active dictionary")
		#perk_resource.level = 0
		#button.set_pressed_no_signal(true)
	# always recheck status of dependencies
	#for unlock in unlocks:
		#unlock.recalculate()
	#for lock in locks:
		#lock.recalculate()

func recalculate() -> void:
	if locked_by.any(func(lock: PerkButton) -> bool: return lock.perk_resource._level > 0):
		button.disabled = true
	elif unlocked_by.all(func(lock: PerkButton) -> bool: return lock.perk_resource._level > 0):
		visible = true
	
	if not perk_resource.get_perk_cost().can_afford():
		button.disabled = true
	
	#var unlock_perks = Perks.active_perks[perk_name].unlocked_by
	#var lock_perks = Perks.active_perks[perk_name].locked_by

	#button.disabled = !unlock_perks.all(func(perk: Perk) -> bool: return perk.enabled) or !lock_perks.all(func(perk: Perk) -> bool: return !perk.enabled)

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
		
	#for unlock in unlocks:
		#unlock.recalculate()
	#for lock in locks:
		#lock.recalculate()
