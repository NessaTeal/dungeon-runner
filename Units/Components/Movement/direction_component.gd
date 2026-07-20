extends Node
class_name DirectionComponent

var direction = 0.0
@export var base_turn_rate = PI / 3
var turn_rate = 0.0
@export var player: Player

signal player_turned_a_lot

var rotation_buffer := 0.0
var real_delta_turn := 0.0
var dir := 0.0

func _ready():
	Perks.affixes_changed.connect(_reset)
	_reset()

func _reset():
	var new_turn_rate = base_turn_rate * (1.0 + (Perks.get_total_affixes_power(DressageTurnRateAffix) / 100.0))
	if turn_rate != new_turn_rate:
		turn_rate = new_turn_rate

func get_dir() -> Vector2:
	return Vector2.UP.rotated(-direction)

func _process(delta: float) -> void:
	var delta_turn := turn_rate * delta
	
	# TODO: fix rotations
	if Input.is_action_pressed("GoLeft"):
		dir = 1.0
		real_delta_turn = minf(real_delta_turn + delta_turn / 15, delta_turn)
		#print(real_delta_turn)
		#rotation_buffer += delta_turn
	elif Input.is_action_pressed("GoRight"):
		dir = -1.0
		real_delta_turn = minf(real_delta_turn + delta_turn / 15, delta_turn)
		#rotation_buffer -= delta_turn
	else:
		real_delta_turn /= 2.0
		if (real_delta_turn < turn_rate / 10):
			real_delta_turn = 0.0
	
	direction += real_delta_turn * dir
	direction = fposmod(direction, TAU)
	#if rad_to_deg(absf(rotation_buffer)) > Map.MAP_TILE_DRAW_ANGLE:
		#player_turned_a_lot.emit()
		#rotation_buffer = 0
	
	player.set_global_rotation(Vector3(0, direction, 0))
