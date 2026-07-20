extends BaseAffix
class_name AttackSpeedAffix

func get_scaled_power() -> float:
	return get_total_power() / 5.0
