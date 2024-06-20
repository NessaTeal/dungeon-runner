extends Control

class_name BaseUnit

@export var unit_name: String = 'Unit Name'

@onready var unit_name_label: Label = $Name
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent

signal hp_updated(current_hp, max_hp)
signal unit_died

# Called when the node enters the scene tree for the first time.
func _ready():
	unit_name_label.text = unit_name
