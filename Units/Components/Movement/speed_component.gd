extends BaseComponent
class_name SpeedComponent

var distance := 0.0
var current_speed := 0.0
var fight_speed := 0.0
var acceleration := 0.0
var speed_from_acceleration := 0.0
var speed_boost_halflife = 0.2
var current_speed_boost = 0.0
var boost_per_apple = 0.0

func _process(delta: float) -> void:
	distance += get_current_speed() * delta
	speed_from_acceleration += acceleration * delta
	current_speed_boost *= exp(-delta/speed_boost_halflife)

func get_current_speed() -> float:
	return current_speed + speed_from_acceleration + get_dynamic_value() + current_speed_boost
