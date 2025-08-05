extends Node
class_name MovementComponent

@export var direction_component: DirectionComponent
@export var speed_component: SpeedComponent
@export var player: Player

signal moved_a_lot

var movement_buffer := 0.0
var total_distance := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed_multiplier := 2.0 if Input.is_action_pressed("GoUp") else 0.5 if Input.is_action_pressed("GoDown") else 1.0
	var delta_movement := speed_component.get_current_speed() * delta * speed_multiplier
	
	move_forward(delta_movement)
	
	movement_buffer += delta_movement

	if movement_buffer > Map.MAP_TILE_SIZE / 10.0:
		moved_a_lot.emit()
		movement_buffer = 0
		
func move_forward(distance: float) -> void:
	total_distance += distance
	#player.position += Vector3(0, 0, 1)
	var direction := direction_component.get_dir()
	player.position += Vector3(direction.x, 0, direction.y) * distance
