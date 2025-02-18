extends Node
class_name MovementComponent

@export var direction_component: DirectionComponent
@export var speed_component: SpeedComponent
@export var player: Player

signal moved_a_lot

var last_pos = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var delta_movement = direction_component.direction * speed_component.get_current_speed() * delta
	player.position += delta_movement
	
	if (last_pos - player.position).length_squared() > Chunk.CHUNK_SIZE_SQUARED:
		last_pos = player.position
		moved_a_lot.emit()
