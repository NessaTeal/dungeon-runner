extends PlayerAffix
class_name CollectibleMagnetRadiusAffix

func apply() -> void:
	player.collectible_magnet_component.magnet_radius += get_value()
