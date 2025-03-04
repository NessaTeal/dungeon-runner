extends Control
class_name SpeedComponent

var distance = 0
var current_speed = 0
var fight_speed = 0.0
var acceleration = 0
var speed_from_acceleration = 0.0

@export var base_speed = 500
@export var fighting_component: FightingComponent

func _ready():
	current_speed = base_speed

func _process(delta):
	distance += get_current_speed() * delta
	speed_from_acceleration += acceleration * delta

func get_current_speed():
	var speed_multiplier = fight_speed if fighting_component.fighting else 1.0
	return (current_speed + speed_from_acceleration) * speed_multiplier

func reset():
	current_speed = base_speed
	acceleration = 0
	fight_speed = 0
