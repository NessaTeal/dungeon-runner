extends BaseAffix

func _init():
	component = MovementComponent

func get_value():
	return power / 200.0

func apply(actual_component: MovementComponent):
	actual_component.fight_speed += get_value()
