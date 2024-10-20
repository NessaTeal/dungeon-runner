extends BaseAffix

func _init():
	component = SpeedComponent
	
func get_value():
	return power / 10.0

func apply(actual_component: SpeedComponent):
	actual_component.current_speed += get_value()
