extends PlayerAffix
class_name DashSpeedAffix

func apply() -> void:
	player.dash_component.dash_speed += get_value()
