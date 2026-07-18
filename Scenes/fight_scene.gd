extends Node
class_name FightScene

@export var player: Player
@export var distance_label: Label
@export var speed_label: Label
@export var chance_label: Label
@export var map: Map
@export var subviewport: SubViewport
@export var main_camera: Camera3D
@export var top_view_camera: Camera3D
@export var ui: CanvasLayer
@export var apple_count: Label
@export var grit_container: HBoxContainer

var enemy_scene: PackedScene = preload("res://Units/Enemy/enemy.tscn")
var item: PackedScene = preload("res://Inventory/item.tscn")

var time_passed := 0.0
var fighting := false
var angle := 0.0

func _ready() -> void:
	map.update_map(Vector3(player.position.x, 0, player.position.z), player.direction_component.get_dir())
	
	Utils.handled_connect(player.health_component.hp_depleted, _on_player_unit_died)
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("SpeeHack"):
		Engine.time_scale = 5
	else:
		Engine.time_scale = 1
	
	time_passed += delta
	
	# TODO: fix this properly that unpause tries to read freed component
	if is_instance_valid(player):
		speed_label.text = "%.01f" % player.speed_component.get_current_speed()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.as_text() == "Z" and event.is_pressed():
		var state := main_camera.current
		if state:
			top_view_camera.current = state
		else:
			main_camera.current = !state


func _on_player_unit_died() -> void:
	get_tree().paused = true
	Meta.save_game()
	
	var game_over := preload("res://Scenes/game_over.tscn").instantiate() as GameOver

	ui.add_child(game_over)

func _on_enemy_died() -> void:
	Collectible.souls += CurrentRunState.souls_per_enemy

func _on_show_inventory_button_pressed() -> void:
	Inventory.show()
