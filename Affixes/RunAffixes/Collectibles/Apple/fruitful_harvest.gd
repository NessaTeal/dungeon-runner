extends RunAffix
class_name FruitfulHarvestAffix

func apply() -> void:
	CurrentRunState.apple_cluster_chance += get_value() / 100.0
