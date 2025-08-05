extends Control

const fight_scene = preload("res://Scenes/fight_scene.tscn")
const perks_scene = preload("res://Scenes/perks_scene.tscn")
const item = preload("res://Inventory/item.tscn")

func _on_button_pressed() -> void:
	var a := fight_scene.instantiate()
	add_sibling(a)
	visible = false
	queue_free()

func _on_button_2_pressed() -> void:
	add_child(perks_scene.instantiate())

func _on_button_3_pressed() -> void:
	var new_item := item.instantiate() as Item
	new_item.stone = StoneGenerator.generate_stone()
	new_item.texture = preload("res://Textures/06_t.PNG")
	Inventory.add_item(new_item)
