extends Node

@export var enemy_scene: PackedScene
@export var player: Player
@export var spawn_path: Path2D
@export var spawn_point: PathFollow2D
@export var spawn_node: Node

@export var spawn_distance: float = 1800

func spawn_enemy():
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.player = player
	spawn_node.add_child(enemy)
	#enemy.scale_enemy(1 + time_passed / 10)
	
	var angle = randf() * TAU
	
	#spawn_point.progress_ratio = randf()
	enemy.set_position(player.global_position + Vector2(spawn_distance, 0).rotated(angle));
	enemy.attack_component.attack_happened.connect(player.health_component._on_receive_damage)
	#enemy.setup_enemy(player)
	#enemy.health_component.hp_depleted.connect(_on_enemy_died, CONNECT_ONE_SHOT)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
