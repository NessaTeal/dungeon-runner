extends Control

@export var icon: Texture
@export var perk_name: String

@onready var button: Button = $Button
@onready var label: Label = $Label
@onready var icon_component: TextureRect = $Icon

signal perks_point_changed

var halo_normal = preload("res://ui_icon_empty_white.png")
var halo_golden = preload("res://ui_icon_empty_orange.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	icon_component.texture = icon
	label.text = perk_name
	var perk_active = Perks.active_perks[perk_name].state
	button.set_pressed_no_signal(perk_active)
	if perk_active:
		button.icon = halo_golden
	

func _on_button_toggled(button_pressed):
	
	if button_pressed:
		if Perks.perk_points > 0:
			button.icon = halo_golden
			Perks.perk_points -= 1
			Perks.active_perks[perk_name].state = button_pressed
		else:
			button.set_pressed_no_signal(false)
	else:
		button.icon = halo_normal
		Perks.perk_points += 1
		Perks.active_perks[perk_name].state = button_pressed
		
	perks_point_changed.emit()
