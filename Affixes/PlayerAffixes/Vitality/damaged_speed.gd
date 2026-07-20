extends BaseAffix
class_name DamagedSpeedAffix

func get_dynamic_value() -> float:
	# Maybe find Player properly and not through singleton
	return minf((1 - Player.instance.health_component.get_health_percentage()) / 0.6, 1) * get_value()
