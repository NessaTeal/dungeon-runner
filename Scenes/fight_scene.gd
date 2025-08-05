extends Node

@export var player: Player
@export var distance_label: Label
@export var speed_label: Label
@export var chance_label: Label
@export var game_state: GameState
@export var map: Map
@export var subviewport: SubViewport
@export var main_camera: Camera3D
@export var top_view_camera: Camera3D
@export var ui: CanvasLayer

var enemy_scene: PackedScene = preload("res://Units/Enemy/enemy.tscn")
var main_menu: PackedScene = preload("res://Scenes/main_menu.tscn")
var item: PackedScene = preload("res://Inventory/item.tscn")

var enemy: Enemy

var time_passed := 0.0
var fighting := false
var angle := 0.0

func _ready() -> void:
	map.update_map(player.get_2d_position(), player.direction_component.get_dir())

func _process(delta: float) -> void:
	if Input.is_action_pressed("SpeeHack"):
		Engine.time_scale = 5
	else:
		Engine.time_scale = 1
	
	time_passed += delta
	
	speed_label.text = "%.01f" % player.speed_component.get_current_speed()
	
func _unhandled_key_input(event: InputEvent) -> void:
	if event.as_text() == "Z" and event.is_pressed():
		var state := main_camera.current
		if state:
			top_view_camera.current = state
		else:
			main_camera.current = !state


func _on_enemy_died() -> void:
	game_state.fight_xp += 50
	fighting = false
	enemy.queue_free()
	var new_item := item.instantiate() as Item
	new_item.stone = StoneGenerator.generate_stone()
	new_item.texture = preload("res://Textures/06_t.PNG")
	Inventory.add_item(new_item)

func _on_button_pressed() -> void:
	get_parent().add_child(preload("res://Scenes/perks_scene.tscn").instantiate())

func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_parent().add_child(main_menu.instantiate())
	queue_free()

func _on_player_unit_died() -> void:
	get_tree().paused = true
	var distance_xp: float = player.movement_component.total_distance ** 1.1
	var total_xp: float = distance_xp + game_state.fight_xp
	var leveled_up: bool = false
	
	Meta.current_xp += total_xp
	
	while Meta.current_xp > Meta.required_xp:
		leveled_up = true
		Perks.perk_points += 1
		Meta.player_level += 1
		Meta.set_xp_for_next_level()
	
	var game_over := preload("res://Scenes/game_over.tscn").instantiate() as GameOver
	
	game_over.level_up.set_visible(leveled_up)
	game_over.xp_bar.set_min(Meta.get_xp_for_level(Meta.player_level - 1))
	game_over.xp_bar.set_max(Meta.required_xp)
	game_over.xp_bar.set_value(Meta.current_xp)
	game_over.xp_count.text = tr("XP_COUNT") % [Meta.current_xp, Meta.required_xp]
	game_over.xp_kills.text = tr("XP_FROM_KILLS") % game_state.fight_xp
	game_over.xp_run.text = tr("XP_FROM_RUN") % distance_xp
	
	ui.add_child(game_over)

func _on_button_3_pressed() -> void:
	add_sibling((preload("res://Scenes/fight_scene.tscn").instantiate()))
	get_tree().paused = false
	queue_free()

func _on_show_inventory_button_pressed() -> void:
	Inventory.show()
