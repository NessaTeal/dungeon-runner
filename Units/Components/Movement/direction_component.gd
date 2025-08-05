extends Node
class_name DirectionComponent

var direction: float = 0
@export var turn_rate: float = PI / 3
@export var player: Player

signal player_turned_a_lot

var rotation_buffer := 0.0

func get_dir() -> Vector2:
	return Vector2.UP.rotated(-direction)

func _process(delta: float) -> void:	
	var delta_turn := turn_rate * delta
	
	if Input.is_action_pressed("GoLeft"):
		direction += delta_turn
	elif Input.is_action_pressed("GoRight"):
		direction -= delta_turn
		
	direction = fposmod(direction, TAU)
	
	rotation_buffer += delta_turn
	
	if rad_to_deg(absf(rotation_buffer)) > Map.MAP_TILE_DRAW_ANGLE / 10.0:
		player_turned_a_lot.emit()
		rotation_buffer = 0
	
	player.set_global_rotation(Vector3(0, direction, 0))
