extends Node
class_name GameState

var base_encounter_chance: float = 1.0
var encounter_chance: float = 1.0
var encounter_chance_increase: float = 1.0/10

var fight_xp: float = 0

func _on_enemy_died() -> void:
	fight_xp += 50
	var new_item := preload("res://Inventory/item.tscn").instantiate() as Item
	new_item.stone = StoneGenerator.generate_stone()
	new_item.texture = preload("res://Textures/06_t.PNG")
	Inventory.add_item(new_item)
