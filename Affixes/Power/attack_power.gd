extends BaseAffix

func _init():
	component = AttackComponent

func get_value():
	return power / 10.0

func apply(actual_component: AttackComponent):
	actual_component.damage += get_value()
