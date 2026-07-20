extends BaseAffix
class_name AttackPowerAffix

func get_scaled_power() -> float:
	return get_total_power() / 10.0
