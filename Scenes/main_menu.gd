extends Control

var fight_scene: PackedScene = load("res://Scenes/fight_scene.tscn")
var perks_scene: PackedScene = load("res://Scenes/perks_scene.tscn")
var item: PackedScene = load("res://Inventory/item.tscn")

var affix_generator = preload("res://Affixes/affix_stone_generator.gd").new()

func _on_button_pressed():
	get_parent().add_child(fight_scene.instantiate())
	queue_free()


func _on_button_2_pressed():
	add_child(perks_scene.instantiate())


func _on_button_3_pressed():
	var new_item = item.instantiate()
	new_item.stone = affix_generator.generate_stone()
	new_item.texture = preload("res://Textures/06_t.PNG")
	Inventory.add_item(new_item)
