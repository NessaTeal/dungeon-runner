extends Sprite2D

class_name BaseUnit

@export var unit_name: String = 'Unit Name'

#@onready var unit_name_label: Label = $Name
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var fighting_component: FightingComponent = $FightingComponent

signal hp_updated(current_hp, max_hp)
signal unit_died

var components = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	components.merge({
		HealthComponent: health_component,
		AttackComponent: attack_component,
		FightingComponent:fighting_component
	})
