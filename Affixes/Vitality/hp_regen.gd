extends BaseAffix

func _init():
	component = HealthComponent

func get_value():
	return power / 25.0

func apply(actual_component: HealthComponent):
	actual_component.hp_regen += get_value()
