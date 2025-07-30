extends Control

const fight_scene = preload("res://Scenes/fight_scene.tscn")
const perks_scene = preload("res://Scenes/perks_scene.tscn")
const item = preload("res://Inventory/item.tscn")

var affix_generator = preload("res://Affixes/affix_stone_generator.gd").new()

func _on_button_pressed():
	var a = fight_scene.instantiate()
	add_sibling(a)
	visible = false
	queue_free()

func _on_button_2_pressed():
	add_child(perks_scene.instantiate())


func _on_button_3_pressed():
	var new_item = item.instantiate()
	new_item.stone = affix_generator.generate_stone()
	new_item.texture = preload("res://Textures/06_t.PNG")
	Inventory.add_item(new_item)
