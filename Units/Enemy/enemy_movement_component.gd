extends Node

@export var enemy: Enemy
@export var speed: float = 400
var player: Player

func _ready():
	player = enemy.player

func _process(delta: float):
	var move: Vector2 = get_direction_to_player() * speed * delta
	if move.length_squared() > get_distance_to_player():
		enemy.position = player.position
	else:
		enemy.position += move

func get_direction_to_player() -> Vector2:
	return (player.global_position - enemy.global_position).normalized()

func get_distance_to_player() -> float:
	return (player.global_position - enemy.global_position).length_squared()
