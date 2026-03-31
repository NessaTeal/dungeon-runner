extends RunAffix
class_name AppleHealingAffix

func get_scaled_power() -> float:
	return get_power() / 100.0

func apply() -> void:
	CurrentRunState.apple_healing += get_value()
