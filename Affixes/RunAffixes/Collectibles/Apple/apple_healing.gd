extends RunAffix
class_name AppleHealingAffix

func get_scaled_power() -> float:
	return get_total_power() / 100.0
