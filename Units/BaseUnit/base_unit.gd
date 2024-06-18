extends Control

class_name BaseUnit

@export var attack: float = 10
@export var unit_name: String = 'Unit Name'
@export var attack_speed: float = 1.0

@onready var timer: Timer = $Timer
@onready var unit_name_label: Label = $Name
@onready var health_component: HealthComponent = $HealthComponent

signal hp_updated(current_hp, max_hp)
signal unit_attacking(damage)
signal unit_attacked(damage)
signal unit_died

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = attack_speed
	unit_name_label.text = unit_name
	timer.start()

func _on_unit_attacking():
	unit_attacking.emit(attack)
