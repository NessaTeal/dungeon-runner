extends Area2D

var minimum_size = 80
var maximum_size = 310
var difference = maximum_size - minimum_size
var duration = 1
var immolation_damage: float = 0
var already_processed: Array[int] = []

@onready var shape = $CollisionShape2D

func _process(delta: float):
	var circle = (shape.shape as CircleShape2D)
	var radius_delta = difference * delta
	var final_radius = min(maximum_size, circle.radius + radius_delta)
	circle.radius = final_radius

func _on_area_entered(enemy_collision: EnemyCollisionComponent) -> void:
	var enemy_id = enemy_collision.get_rid()
	if already_processed.find(enemy_id) == -1:
		enemy_collision.receive_attack(immolation_damage)
	else:
		already_processed.push_back(enemy_id)

func _on_timer_timeout() -> void:
	queue_free()
