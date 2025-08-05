extends Node
class_name DashComponent

@export var movement_component: MovementComponent 
@export var transformation_component: TransformationComponent

@onready var dash_cooldown_timer: Timer = $DashCooldown

var dashing := false
var dash_speed := 1000.0
var dash_duration := 0.2
var remaining_dash_duration := 0.0

func _process(delta: float) -> void:
	if dashing:
		var dash_duration_to_apply := minf(delta, remaining_dash_duration)
		var dash_dist := dash_speed * dash_duration_to_apply
		movement_component.move_forward(dash_dist)
		remaining_dash_duration -= dash_duration_to_apply
		if remaining_dash_duration == 0:
			dashing = false
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Dash") && dash_cooldown_timer.is_stopped():
		transformation_component.transform("water")
		dashing = true
		remaining_dash_duration = dash_duration
		dash_cooldown_timer.start()
