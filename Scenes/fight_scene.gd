extends Control

@onready var player: Player = $Player
@onready var distance_label: Label = $Distance
@onready var speed_label: Label = $Speed
@onready var chance_label: Label = $Chance
@onready var spawn_timer: Timer = $SpawnTimer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var game_state: GameState = $GameState
@onready var game_over: Control = $GameOver

@export var enemy_scene: PackedScene

var main_menu: PackedScene = load("res://Scenes/main_menu.tscn")

var enemy: Enemy

var time_passed = 0

signal encounter_started
signal encounter_ended

func _process(delta):
	if Input.is_action_pressed("SpeeHack"):
		Engine.time_scale = 5
	else:
		Engine.time_scale = 1
	
	time_passed += delta
	
	distance_label.text = "%.02f" % game_state.distance
	
	speed_label.text = "%.01f" % game_state.modified_move_speed
	
	if !game_state.fighting:
		progress_bar.value = (1 - spawn_timer.time_left) * 100

func _on_spawn_timer_timeout():
	if !game_state.fighting:
		if randf() < game_state.encounter_chance:
			spawn_enemy()
		else:
			game_state.encounter_chance += game_state.encounter_chance_increase
			chance_label.text = "%d" % (game_state.encounter_chance * 100)

func _on_enemy_died():
	game_state.fight_xp += 50
	encounter_ended.emit()
	game_state.fighting = false
	enemy.queue_free()
	spawn_timer.start()

func spawn_enemy():
	spawn_timer.stop()
	progress_bar.value = 0
	enemy = enemy_scene.instantiate()
	
	enemy.set_position(Vector2(700, 0));
	player.unit_attacking.connect(Callable(enemy, '_on_unit_attacked'))
	enemy.unit_attacking.connect(Callable(player, '_on_unit_attacked'))
	enemy.unit_died.connect(_on_enemy_died)
	game_state.encounter_chance = game_state.base_encounter_chance
	chance_label.text = "%d" % (game_state.encounter_chance * 100)
	
	var enemy_ready = func():
		enemy.scale_enemy(1 + time_passed / 10)
	enemy.ready.connect(enemy_ready)
	
	add_child(enemy)
	
	encounter_started.emit()
	game_state.fighting = true
	

func _on_button_pressed():
	get_parent().add_child(load("res://Scenes/perks_scene.tscn").instantiate())


func _on_button_2_pressed():
	get_tree().paused = false
	get_parent().add_child(main_menu.instantiate())
	queue_free()


func _on_player_unit_died():
	get_tree().paused = true
	var distance_xp: float = game_state.distance ** 1.1
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
