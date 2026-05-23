extends RunAffix
class_name GritGainAffix

func apply() -> void:
	CurrentRunState.grit_per_minute += get_value()
