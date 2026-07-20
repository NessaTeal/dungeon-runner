extends Area3D
class_name CollectibleMagnetComponent

@export var cylinder_shape: CylinderShape3D
@export var magnet_radius = 0.1:
	set(value):
		magnet_radius = value
		cylinder_shape.radius = value
@export var magnet_strength = 0.0
@export var player: Player

var tracked_collectibles: Array[Collectible]

func _process(delta: float) -> void:
	if not magnet_radius or not magnet_strength:
		return
	
	for collectible in tracked_collectibles:
		var direction = (player.global_position - collectible.global_position).normalized()
		collectible.global_position += direction * magnet_strength * delta

func _on_area_entered(collectible: Collectible):
	tracked_collectibles.push_back(collectible)

func _on_area_exited(collectible: Collectible) -> void:
	tracked_collectibles.erase(collectible)
