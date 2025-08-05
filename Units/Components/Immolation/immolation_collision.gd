extends Area2D
class_name ImmolationCollision

var minimum_size := 80
var maximum_size := 310
var difference := maximum_size - minimum_size
var duration := 1
var immolation_damage: float = 0
var already_processed: Dictionary[RID, bool] = {}

@export var shape: CollisionShape2D

func _process(delta: float) -> void:
	var circle := (shape.shape as CircleShape2D)
	var radius_delta := difference * delta
	var final_radius := minf(maximum_size, circle.radius + radius_delta)
	circle.radius = final_radius

func _on_area_entered(enemy_collision: EnemyCollisionComponent) -> void:
	var enemy_id := enemy_collision.get_rid()
	if !already_processed.has(enemy_id):
		enemy_collision.receive_attack(immolation_damage)
	else:
		already_processed[enemy_id] = true

func _on_timer_timeout() -> void:
	queue_free()
