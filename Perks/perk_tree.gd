extends ColorRect
class_name PerkTree

@export var perk_buttons: Control

signal perks_changed

func _ready() -> void:
	for button: PerkButton in perk_buttons.get_children():
		@warning_ignore("return_value_discarded")
		button.button.toggled.connect(func(_arg: bool) -> void: perks_changed.emit())
		button.recalculate()
