extends Control

@onready var player: Player = $SubViewportContainer/SubViewport/Player
@onready var distance_label: Label = $UI/Distance
@onready var speed_label: Label = $UI/Speed
@onready var chance_label: Label = $UI/Chance
@onready var game_state: GameState = $GameState
@onready var game_over: Control = $UI/GameOver
@onready var map = $SubViewportContainer/SubViewport/Map
@onready var subviewport = $SubViewportContainer/SubViewport

@export var enemy_scene: PackedScene

var main_menu: PackedScene = load("res://Scenes/main_menu.tscn")
var item: PackedScene = load("res://Inventory/item.tscn")
var affix_generator = preload("res://Affixes/affix_stone_generator.gd").new()

var enemy: Enemy

var time_passed = 0
var fighting = false
var angle = 0.0

signal encounter_started
signal encounter_ended

func _ready():
	player.health_component.hp_depleted.connect(_on_player_unit_died, CONNECT_ONE_SHOT)
	player.movement_component.moved_a_lot.connect(_on_player_moved_a_lot)
	

func _process(delta):
	if Input.is_action_pressed("SpeeHack"):
		Engine.time_scale = 5
	else:
		Engine.time_scale = 1
	
	time_passed += delta
	
	#distance_label.text = "%.02f" % player.movement_component.distance
	
	var current_speed = player.speed_component.get_current_speed()
	
	speed_label.text = "%.01f" % player.speed_component.get_current_speed()


func _on_enemy_died():
	game_state.fight_xp += 50
	encounter_ended.emit()
	fighting = false
	enemy.queue_free()
	var new_item = item.instantiate()
	new_item.stone = affix_generator.generate_stone()
	new_item.texture = preload("res://Textures/06_t.PNG")
	Inventory.add_item(new_item)

func _on_button_pressed():
	get_parent().add_child(load("res://Scenes/perks_scene.tscn").instantiate())


func _on_button_2_pressed():
	get_tree().paused = false
	get_parent().add_child(main_menu.instantiate())
	queue_free()


func _on_player_unit_died():
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
			
	game_over.get_node("HBoxContainer/LevelUp").set_visible(leveled_up)
	game_over.get_node("HBoxContainer/PlayerLevel").text = tr("PLAYER_LEVEL") % Meta.player_level
	var xp_bar: ProgressBar = game_over.get_node("XPProgress")
	xp_bar.set_min(Meta.get_xp_for_level(Meta.player_level - 1))
	xp_bar.set_max(Meta.required_xp)
	xp_bar.set_value(Meta.current_xp)
	game_over.get_node("XPCount").text = tr("XP_COUNT") % [Meta.current_xp, Meta.required_xp]
	game_over.get_node("XPKills").text = tr("XP_FROM_KILLS") % game_state.fight_xp
	game_over.get_node("XPRun").text = tr("XP_FROM_RUN") % distance_xp
	game_over.set_visible(true)


func _on_button_3_pressed():
	get_parent().add_child((load("res://Scenes/fight_scene.tscn").instantiate()))
	get_tree().paused = false
	queue_free()

func _on_show_inventory_button_pressed() -> void:
	Inventory.show()

func _on_player_moved_a_lot() -> void:
	map.update_map(player.position)
