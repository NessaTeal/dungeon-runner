extends RunAffix
class_name SpawnChanceAffix

func apply() -> void:
	CurrentRunState.spawn_chance += get_value()
