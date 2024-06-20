extends Control
class_name MovementComponent

var distance = 0
var current_speed = 0
var fight_speed = 0.0
@export var base_speed = 10
@export var acceleration = 0

@export var fighting_component: FightingComponent

func _ready():
	current_speed = base_speed

func _process(delta):
	distance += get_current_speed() * delta
	current_speed += acceleration * delta

func get_current_speed():
	var speed_multiplier = fight_speed if fighting_component.fighting else 1.0
	return current_speed * speed_multiplier
