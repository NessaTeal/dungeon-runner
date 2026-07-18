extends VBoxContainer
class_name GameOver

func _on_button_pressed() -> void:
	get_parent().add_child(preload("res://Scenes/perks_scene.tscn").instantiate())

func _on_button_2_pressed() -> void:
	var game_holder = get_parent().get_parent()
	assert(game_holder is not FightScene)
	var fight_scene = game_holder.get_parent()
	assert(fight_scene is FightScene)
	fight_scene.add_child(Asset.Instantiate(MainMenu))
	get_tree().paused = false
	game_holder.queue_free()

func _on_button_3_pressed() -> void:
	var fight_scene = get_parent().get_parent().get_parent()
	assert(fight_scene is FightScene)
	fight_scene.add_sibling(Asset.Instantiate(FightScene))
	get_tree().paused = false
	fight_scene.queue_free()
