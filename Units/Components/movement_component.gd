extends Node
class_name MovementComponent

@export var direction_component: DirectionComponent
@export var speed_component: SpeedComponent
@export var player: Player

@onready var dash_cooldown_timer: Timer = $DashCooldown

signal moved_a_lot

var last_pos = Vector2.ZERO
var dashing: bool = false
var dash_speed: float = 1000
var dash_duration: float = 0.2
var remaining_dash_duration: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed_multiplier = 2 if Input.is_action_pressed("GoUp") else 0.5 if Input.is_action_pressed("GoDown") else 1
	var delta_movement = direction_component.get_dir() * speed_component.get_current_speed() * delta * speed_multiplier
	
	player.position += delta_movement
	
	if dashing:
		var dash_duration_to_apply = min(delta, remaining_dash_duration)
		var dash_dist = dash_speed * dash_duration_to_apply
		player.position += direction_component.get_dir() * dash_dist
		remaining_dash_duration -= dash_duration_to_apply
		if remaining_dash_duration == 0:
			dashing = false

	if (last_pos - player.position).length_squared() > Chunk.CHUNK_SIZE_SQUARED:
		last_pos = player.position
		moved_a_lot.emit()
		
func _input(event):
	if event.is_action_pressed("Dash") && dash_cooldown_timer.is_stopped():
		dashing = true
		remaining_dash_duration = dash_duration
		dash_cooldown_timer.start()
