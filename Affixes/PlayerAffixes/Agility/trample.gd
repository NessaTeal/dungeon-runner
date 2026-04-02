extends PlayerAffix
class_name TrampleAffix

func get_scaled_power() -> float:
	return (get_total_power() / 100.0 * 3.0)
	
func apply() -> void:
	player.trample_component.coefficient += get_value()
