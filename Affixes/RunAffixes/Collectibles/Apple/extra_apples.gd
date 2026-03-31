extends RunAffix
class_name ExtraApplesAffix

func apply() -> void:
	CurrentRunState.apples_per_apples += int(get_value())
