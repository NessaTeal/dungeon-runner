extends Collectible
class_name Apple

signal picked_up

const animation_offset = Vector3(0, 0.2, 0)

var time_offset: float
var starting_sprite_position: Vector3

const ANIMATION_STOP_DISTANCE = 50

func _ready() -> void:
	time_offset = randf()
	starting_sprite_position = $Sprite3D.position
	$Sprite3D.position += (1.0 + sin(time_offset * TAU)) * animation_offset

	set_process(Player.instance.global_position.distance_to(global_position) < ANIMATION_STOP_DISTANCE)

func _process(delta: float) -> void:
	time_offset += delta / 4
	$Sprite3D.position = starting_sprite_position + (1.0 + sin(time_offset * TAU)) * animation_offset

func _on_body_entered(player: Player) -> void:
	Collectible.apples += CurrentRunState.apples_per_apples
	player.health_component.heal_damage(CurrentRunState.apple_healing)
	picked_up.emit()
	queue_free()

func _on_timer_timeout() -> void:
	set_process(Player.instance.global_position.distance_to(global_position) < ANIMATION_STOP_DISTANCE)
