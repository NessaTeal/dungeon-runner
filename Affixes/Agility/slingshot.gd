extends BaseAffix

func _init():
	component = SlingshotComponent

func get_value():
	return power / 200.0
	
func get_formatted_value():
	return get_value() * 100

func apply(actual_component: SlingshotComponent):
	actual_component.coefficient += get_value()
