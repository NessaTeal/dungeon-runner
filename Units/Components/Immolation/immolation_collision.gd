extends Area3D
class_name ImmolationCollision

var minimum_size := 0.25
var maximum_size := 2.0
var difference := maximum_size - minimum_size
var duration := 1
var immolation_damage: float = 0
var already_processed: Dictionary[RID, bool] = {}

@export var shape: CylinderShape3D

func _ready() -> void:
	shape.radius = minimum_size

func _process(delta: float) -> void:
	var radius_delta := difference * delta
	var final_radius := minf(maximum_size, shape.radius + radius_delta)
	shape.radius = final_radius

func _on_area_entered(enemy_collision: EnemyHurtboxComponent) -> void:
	var enemy_id := enemy_collision.get_rid()
	if !already_processed.has(enemy_id):
		enemy_collision.receive_attack(immolation_damage)
	else:
		already_processed[enemy_id] = true

func _on_timer_timeout() -> void:
	queue_free()
