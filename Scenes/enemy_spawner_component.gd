extends Node

@export var enemy_scene: PackedScene
@export var player: Player
@export var spawn_node: Node
@export var fight_scene: FightScene

@export_category("Internals")
@export var spawn_distance: float = 50.0
@export var spawn_timer: Timer

#func _ready() -> void:
	#if CurrentRunState.spawn_chance > 0:
		#spawn_timer.wait_time = CurrentRunState.spawn_chance
		#spawn_timer.start()

func spawn_enemy() -> void:
	if randf() > CurrentRunState.spawn_chance:
		return
	
	var enemy := enemy_scene.instantiate() as Enemy
	enemy.player = player
	var angle := randf() * PI - PI / 2
	var position := Vector2(player.position.x, player.position.z) + (player.direction_component.get_dir() * spawn_distance).rotated(angle)

	enemy.set_position(Vector3(position.x, 0, position.y));
	spawn_node.add_child(enemy)
	#enemy.scale_enemy(1 + time_passed / 10.0)
	
	Utils.handled_connect(enemy.attack_component.attack_happened, player.health_component._on_receive_damage)
	Utils.handled_connect(enemy.unit_died, fight_scene._on_enemy_died)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
