extends Node
class_name TrampleComponent

@export var attack_component: AttackComponent
@export var movement_component: SpeedComponent

var coefficient = 0

func _ready():
	attack_component.dynamic_damage.push_back(self)
	
func get_value():
	return movement_component.current_speed * coefficient

func reset():
	coefficient = 0
