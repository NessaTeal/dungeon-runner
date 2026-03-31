extends VBoxContainer
class_name GameOver

@export var level_up: Label
@export var player_level: Label
@export var xp_count: Label
@export var xp_run: Label
@export var xp_kills: Label
@export var xp_bar: ProgressBar

func _on_button_pressed() -> void:
	get_parent().add_child(preload("res://Scenes/perks_scene.tscn").instantiate())

func _on_button_2_pressed() -> void:
	get_parent().get_parent().get_parent().add_child(load("res://Scenes/main_menu.tscn").instantiate())
	get_parent().get_parent().queue_free()
	get_tree().paused = false

func _on_button_3_pressed() -> void:
	get_parent().get_parent().add_sibling((load("res://Scenes/fight_scene.tscn").instantiate()))
	get_tree().paused = false
	get_parent().get_parent().queue_free()
