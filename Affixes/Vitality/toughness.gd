extends BaseAffix

func _init():
	component = HealthComponent

func get_value():
	return power * 2

func apply(actual_component: HealthComponent):
	actual_component.max_hp += get_value()
