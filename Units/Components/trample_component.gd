extends ValueComponent
class_name TrampleComponent

@export var attack_component: AttackComponent
@export var movement_component: SpeedComponent

var coefficient := 0.0

func _ready() -> void:
	attack_component.dynamic_damage.push_back(self)
	
func get_value() -> float:
	return movement_component.current_speed * coefficient

func reset() -> void:
	coefficient = 0.0
