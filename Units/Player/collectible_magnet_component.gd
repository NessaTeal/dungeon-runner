extends Area3D
class_name CollectibleMagnetComponent

@export var cylinder_shape: CylinderShape3D
@export var magnet_radius = 0.0:
	set(value):
		magnet_radius = value
		cylinder_shape.radius = value
@export var magnet_strength = 0.0
@export var player: Player

var tracked_collectibles: Array[Collectible]

func _ready():
	Perks.affixes_changed.connect(_reset)
	_reset()

func _reset():
	var new_magnet_radius = Perks.get_total_affixes_power(CollectibleMagnetRadiusAffix)
	if magnet_radius != new_magnet_radius:
		magnet_radius = new_magnet_radius
		
	var new_magnet_strength = Perks.get_total_affixes_power(CollectibleMagnetStrengthAffix)
	if magnet_strength != new_magnet_strength:
		magnet_strength = new_magnet_strength

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
