extends Collectible
class_name Apple

const animation_offset = Vector3(0, 0.2, 0)

var time_offset: float
var starting_sprite_position: Vector3

func _ready() -> void:
	time_offset = randf() * 4000.0
	starting_sprite_position = $Sprite3D.position

func _process(_delta: float) -> void:
	$Sprite3D.position = starting_sprite_position + (1.0 + sin((Time.get_ticks_msec() - time_offset) / 4000.0 * TAU)) * animation_offset

func _on_body_entered(player: Player) -> void:
	Collectible.apples += CurrentRunState.apples_per_apples
	player.health_component.heal_damage(CurrentRunState.apple_healing)
	queue_free()
