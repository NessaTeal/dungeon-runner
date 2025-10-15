extends Node
class_name EnemyMovementComponent

@export var enemy: Enemy
@export var speed := 1.0
var player: Player

func _ready() -> void:
	player = enemy.player

func _process(delta: float) -> void:
	var move: Vector3 = (get_interception_point() - enemy.position).normalized() * speed + Utils.GRAVITY_VECTOR
	enemy.velocity = move
	enemy.move_and_slide()

func get_direction_from_player() -> Vector3:
	return enemy.position - player.position

func get_distance_to_player() -> float:
	return (player.global_position - enemy.global_position).length_squared()

func get_interception_point() -> Vector3:
	var player_velocity_2d := player.direction_component.get_dir() * player.speed_component.get_current_speed()
	var player_velocity := Vector3(player_velocity_2d.x, 0, player_velocity_2d.y)
	var a := speed ** 2 - player.speed_component.get_current_speed() ** 2
	var b := 2 * (get_direction_from_player().dot(player_velocity))
	var c := - get_distance_to_player()
	
	var d := b ** 2 - 4 * a * c
	
	if d < 0:
		# no real solutions, just return player position 
		return player.position
		
	var d_sqrt := sqrt(d)
	
	var t_0 := (-b + d_sqrt) / (2 * a)
	var t_1 := (-b - d_sqrt) / (2 * a)
	
	var t_final: float
	if t_0 < 0:
		if t_1 < 0:
			# both solutions require "time-travel" which is not possible, just return player position
			return player.position
		else:
			t_final = t_1
	elif t_1 < 0:
		t_final = t_0
	else:
		t_final = min(t_0, t_1)
	
	var final_position := player.position + player_velocity * t_final
	return final_position
