extends BaseAffix

func _init():
	component = MovementComponent

func get_value():
	return power / 10.0

func apply(actual_component: MovementComponent):
	actual_component.acceleration += get_value()
