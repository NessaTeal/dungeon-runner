extends BaseAffix

func _init():
	component = SpeedComponent

func get_value():
	return power / 200.0

func apply(actual_component: SpeedComponent):
	actual_component.fight_speed += get_value()
