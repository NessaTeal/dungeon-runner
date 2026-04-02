extends PlayerAffix
class_name SlingshotAffix

func get_scaled_power() -> float:
	return get_total_power() / 200.0

func apply() -> void:
	player.slingshot_component.coefficient += get_value() / 100
