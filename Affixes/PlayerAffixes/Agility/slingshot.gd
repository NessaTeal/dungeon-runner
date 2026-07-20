extends BaseAffix
class_name SlingshotAffix

func get_scaled_power() -> float:
	return get_total_power() / 200.0
