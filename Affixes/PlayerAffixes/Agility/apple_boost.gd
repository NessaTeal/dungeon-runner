extends PlayerAffix
class_name AppleBoostAffix

func apply() -> void:
	player.speed_component.boost_per_apple += get_value()
