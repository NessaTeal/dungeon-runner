extends ColorRect

@onready var perk_points_label: Label = $PerkPointsLabel
@onready var perk_tree = $PerkTree

func _ready():
	perk_points_label.text = tr("PERK_POINTS_AVAILABLE") % Perks.perk_points

func _on_button_pressed():
	queue_free()

func _on_tree_selector_tab_changed(tab:int):
	perk_tree.queue_free()
	var new_perk_tree = select_tab(tab).instantiate()
	perk_tree = new_perk_tree

	add_child(new_perk_tree)

	move_child(new_perk_tree, 0)

	new_perk_tree.perk_changed.connect(_on_perk_tree_perk_changed)


func select_tab(tab: int):
	if tab == 0:
		return load("res://Perks/Agility/agility_tree.tscn")
	else:
		return load("res://Perks/Vitality/vitality_tree.tscn")

func _on_perk_tree_perk_changed():
	perk_points_label.text = tr("PERK_POINTS_AVAILABLE") % Perks.perk_points
