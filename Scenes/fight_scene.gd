extends Control

@onready var player: Player = $Player
@onready var distance_label: Label = $Distance
@onready var speed_label: Label = $Speed
@onready var chance_label: Label = $Chance
@onready var spawn_timer: Timer = $SpawnTimer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var game_state: GameState = $GameState
@onready var game_over: Control = $GameOver
@onready var parallax: ParallaxBackground = $ParallaxBackground

@export var enemy_scene: PackedScene

var main_menu: PackedScene = load("res://Scenes/main_menu.tscn")
var item: PackedScene = load("res://Inventory/item.tscn")
var affix_generator = preload("res://Affixes/affix_stone_generator.gd").new()

var enemy: Enemy

var time_passed = 0
var fighting = false

signal encounter_started
signal encounter_ended

func _ready():
	encounter_started.connect(player.fighting_component.start_fight)
	encounter_ended.connect(player.fighting_component.stop_fight)
	player.health_component.hp_depleted.connect(_on_player_unit_died)

func _process(delta):
	if Input.is_action_pressed("SpeeHack"):
		Engine.time_scale = 5
	else:
		Engine.time_scale = 1
	
	time_passed += delta
	
	distance_label.text = "%.02f" % player.movement_component.distance
	
	var current_speed = player.movement_component.get_current_speed()
	
	speed_label.text = "%.01f" % player.movement_component.get_current_speed()
	
	if current_speed > 0:
		parallax.scroll_offset += Vector2(-current_speed * delta, 0)
	
	if !fighting:
		progress_bar.value = (1 - spawn_timer.time_left) * 100
		

func _on_spawn_timer_timeout():
	if !fighting:
		if randf() < game_state.encounter_chance:
			spawn_enemy()
		else:
			game_state.encounter_chance += game_state.encounter_chance_increase
			chance_label.text = "%d" % (game_state.encounter_chance * 100)

func _on_enemy_died():
	game_state.fight_xp += 50
	encounter_ended.emit()
	fighting = false
	enemy.queue_free()
	spawn_timer.start()
	var new_item = item.instantiate()
	new_item.stone = affix_generator.generate_stone()
	new_item.texture = preload("res://Textures/06_t.PNG")
	Inventory.add_item(new_item)

func spawn_enemy():
	spawn_timer.stop()
	progress_bar.value = 0
	enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.fighting_component.start_fight()
	enemy.scale_enemy(1 + time_passed / 10)
	
	enemy.set_position(Vector2(700, 0));
	player.attack_component.attack_happened.connect(enemy.health_component._on_receive_damage)
	enemy.attack_component.attack_happened.connect(player.health_component._on_receive_damage)
	enemy.health_component.hp_depleted.connect(_on_enemy_died, CONNECT_ONE_SHOT)
	game_state.encounter_chance = game_state.base_encounter_chance
	chance_label.text = "%d" % (game_state.encounter_chance * 100)
	
	fighting = true
	encounter_started.emit()

func _on_button_pressed():
	get_parent().add_child(load("res://Scenes/perks_scene.tscn").instantiate())


func _on_button_2_pressed():
	get_tree().paused = false
	get_parent().add_child(main_menu.instantiate())
	queue_free()


func _on_player_unit_died():
	get_tree().paused = true
	var distance_xp: float = player.movement_component.distance ** 1.1
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
	queue_free()
	get_tree().paused = false


func _on_show_inventory_button_pressed() -> void:
	Inventory.show()
