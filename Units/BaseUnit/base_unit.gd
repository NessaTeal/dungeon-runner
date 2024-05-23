extends Control

class_name BaseUnit

@export var max_hp: float = 100
var hp: float
@export var hp_regen: float = 5
@export var attack: float = 10
@export var unit_name: String = 'Unit Name'
@export var attack_speed: float = 1.0

@onready var hp_bar: ColorRect = $"HPBar/HP bar"
@onready var timer: Timer = $Timer
@onready var unit_name_label: Label = $Name

signal hp_updated(current_hp, max_hp)
signal unit_attacking(damage)
signal unit_attacked(damage)
signal unit_died

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = max_hp
	timer.wait_time = attack_speed
	unit_name_label.text = unit_name
	timer.start()

func update_hp():
	hp_bar.set_size(Vector2(384 * hp / max_hp, 40))

func apply_damage(damage: float):
	hp -= damage
	if hp <= 0:
		unit_died.emit()
	update_hp()

func _on_unit_attacked(damage):
	unit_attacked.emit(damage)
	apply_damage(damage)

func _on_unit_attacking():
	unit_attacking.emit(attack)
