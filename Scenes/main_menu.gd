extends Control

var fight_scene: PackedScene = load("res://Scenes/fight_scene.tscn")
var perks_scene: PackedScene = load("res://Scenes/perks_scene.tscn")

func _on_button_pressed():
	get_parent().add_child(fight_scene.instantiate())
	queue_free()


func _on_button_2_pressed():
	add_child(perks_scene.instantiate())
