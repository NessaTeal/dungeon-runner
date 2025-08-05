extends Node

@export var enemy_scene: PackedScene
@export var player: Player
@export var spawn_path: Path2D
@export var spawn_point: PathFollow2D
@export var spawn_node: Node

@export_category("Internals")
@export var spawn_distance: float = 100
@export var spawn_rate: float = 0.25
@export var spawn_timer: Timer

func _ready() -> void:
	spawn_timer.wait_time = spawn_rate

func spawn_enemy() -> void:
	var enemy := enemy_scene.instantiate() as Enemy
	enemy.player = player
	var angle := randf() * PI - PI / 2
	var position := player.get_2d_position() + (player.direction_component.get_dir() * spawn_distance).rotated(angle)

	enemy.set_position(Vector3(position.x, 0, position.y));
	spawn_node.add_child(enemy)
	#enemy.scale_enemy(1 + time_passed / 10.0)
	
	Utils.handled_connect(enemy.attack_component.attack_happened, player.health_component._on_receive_damage)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
