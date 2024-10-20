extends Node
class_name MovementComponent

@export var direction_component: DirectionComponent
@export var speed_component: SpeedComponent
@export var player: Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player.position += direction_component.direction * speed_component.get_current_speed() * delta
