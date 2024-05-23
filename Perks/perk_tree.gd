extends ColorRect

signal perk_changed

func _on_perk_button_perks_point_changed():
	perk_changed.emit()

	for button: PerkButton in $PerkButtons.get_children():
		button.recalculate()