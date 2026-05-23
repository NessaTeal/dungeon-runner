extends RunAffix
class_name AppleChanceAffix

func apply() -> void:
	CurrentRunState.apple_chance += get_value() / 100.0
