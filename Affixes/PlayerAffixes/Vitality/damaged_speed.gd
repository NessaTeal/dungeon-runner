extends PlayerAffix
class_name DamagedSpeed

const key = "DamagedSpeed"

func apply() -> void:
	player.speed_component.add_dynamic_affix(key, self)

func get_dynamic_value() -> float:
	return minf((1 - player.health_component.get_health_percentage()) / 0.6, 1) * get_value()
