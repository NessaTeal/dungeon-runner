extends Node

@export var enemy: Enemy
@export var speed: float = 400
var player: Player

func _ready():
	player = enemy.player

func _process(delta: float):
	var move: Vector2 = (get_interception_point() - enemy.global_position).normalized() * speed * delta
	if move.length_squared() > get_distance_to_player():
		enemy.global_position = player.global_position
	else:
		enemy.global_position += move

func get_direction_from_player() -> Vector2:
	return enemy.global_position - player.global_position

func get_distance_to_player() -> float:
	return (player.global_position - enemy.global_position).length_squared()

func get_interception_point():
	var a = speed ** 2 - player.speed_component.get_current_speed() ** 2
	var b = 2 * (get_direction_from_player().dot(player.direction_component.get_dir() * player.speed_component.get_current_speed()))
	var c = - get_distance_to_player()
	
	var tmp = sqrt(b ** 2 - 4 * a * c)
	
	var t_0 = (-b + tmp) / (2 * a)
	var t_1 = (-b - tmp) / (2 * a)
	
	var t_final
	if t_0 < 0:
		if t_1 < 0:
			print("Unchaseable")
		else:
			t_final = t_1
	elif t_1 < 0:
		t_final = t_0
	else:
		t_final = min(t_0, t_1)

		
	var final_position = player.global_position + player.direction_component.get_dir() * player.speed_component.get_current_speed() * t_final
	return final_position
