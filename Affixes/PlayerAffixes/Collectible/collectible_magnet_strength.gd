extends PlayerAffix
class_name CollectibleMagnetStrengthAffix

func apply() -> void:
	player.collectible_magnet_component.magnet_strength += get_value()
