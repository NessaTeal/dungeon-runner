extends ColorRect

@onready var perk_points_label: Label = $PerkPointsLabel

func _ready():
	perk_points_label.text = tr("PERK_POINTS_AVAILABLE") % Perks.perk_points

func _on_button_pressed():
	queue_free()

func _on_perk_button_perks_point_changed():
	perk_points_label.text = tr("PERK_POINTS_AVAILABLE") % Perks.perk_points
