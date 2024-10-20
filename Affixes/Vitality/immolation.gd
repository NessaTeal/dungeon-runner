extends BaseAffix

func _init():
	component = ImmolationComponent

func get_value():
	return power / 20.0

func apply(actual_component: ImmolationComponent):
	actual_component.immolation += get_value()
