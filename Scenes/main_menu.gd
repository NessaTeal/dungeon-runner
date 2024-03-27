extends Control

var fight_scene: PackedScene = load("res://Scenes/fight_scene.tscn")
var agility_tree: PackedScene = load("res://Perks/Agility/agility_tree.tscn")

func _on_button_pressed():
	get_parent().add_child(fight_scene.instantiate())
	queue_free()


func _on_button_2_pressed():
	add_child(agility_tree.instantiate())
