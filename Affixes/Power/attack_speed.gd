extends BaseAffix

func _init():
	component = AttackComponent

func get_value():
	return power / 5.0

func apply(actual_component: AttackComponent):
	actual_component.affix_attack_speed += get_value()
