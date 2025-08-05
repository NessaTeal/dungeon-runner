extends PlayerAffix
class_name TrampleAffix

func get_value() -> float:
	return (power / 100.0 * 3.0)
	
func apply() -> void:
	player.trample_component.coefficient += get_value()
