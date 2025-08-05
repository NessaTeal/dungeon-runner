extends ColorRect

@onready var perk_points_label: Label = $PerkPointsLabel

func _ready() -> void:
	perk_points_label.text = tr("PERK_POINTS_AVAILABLE") % Perks.perk_points

func _on_button_pressed() -> void:
	queue_free()

func _on_perk_tree_perk_changed() -> void:
	perk_points_label.text = tr("PERK_POINTS_AVAILABLE") % Perks.perk_points
