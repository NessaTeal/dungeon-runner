extends Node
class_name MovementComponent

@export var direction_component: DirectionComponent
@export var speed_component: SpeedComponent
@export var player: Player

signal moved_a_lot

var last_pos = Vector3.ZERO
var total_distance: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed_multiplier: float = 2 if Input.is_action_pressed("GoUp") else 0.5 if Input.is_action_pressed("GoDown") else 1
	var delta_movement: float = speed_component.get_current_speed() * delta * speed_multiplier
	
	move_forward(delta_movement)

	if (last_pos - player.position).length_squared() > Chunk.CHUNK_SIZE_SQUARED:
		last_pos = player.position
		moved_a_lot.emit()
		
func move_forward(distance: float):
	total_distance += distance
	#player.position += Vector3(0, 0, 1)
	var direction = direction_component.get_dir()
	player.position += Vector3(direction.x, 0, direction.y) * distance
