extends PlayerAffix
class_name SlingshotAffix

func get_scaled_power() -> float:
	return get_power() / 200.0
	
func get_formatted_value() -> float:
	return get_value() * 100

func apply() -> void:
	player.slingshot_component.coefficient += get_value()
