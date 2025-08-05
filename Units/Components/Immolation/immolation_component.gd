extends GPUParticles2D
class_name ImmolationComponent

@export var immolation_damage := 10.0

@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var transformation_component: TransformationComponent
@export var _2d_component: Node2D
@export var timer: Timer

var immolation_collision: PackedScene = preload("res://Units/Components/Immolation/immolation_collision.tscn")

func _on_timeout() -> void:
	#amount_ratio += 0.01
	emitting = true;
	transformation_component.transform("fire")
	var new_collision := immolation_collision.instantiate() as ImmolationCollision
	new_collision.immolation_damage = immolation_damage
	_2d_component.add_child(new_collision)
	await get_tree().create_timer(0.05).timeout
	emitting = false;
	pass
	#restart()
	#for i in 500:
		#emit_particle(Transform2D(), Vector2(), Color(), Color(), 0)

func reset() -> void:
	immolation_damage = 10.0
