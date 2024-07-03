extends BaseAffix

func _init():
	component = TrampleComponent

func get_value():
	return (power / 100.0 * 3.0)
	
func apply(actual_component: TrampleComponent):
	actual_component.coefficient += get_value()
