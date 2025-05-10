extends GPUParticles2D
class_name ImmolationComponent

@export var immolation = 0.0

@export var health_component: HealthComponent
@export var attack_component: AttackComponent

@onready var timer: Timer = $Timer

func _on_timeout():
	#amount_ratio += 0.01
	emitting = true;
	await get_tree().create_timer(0.05).timeout
	emitting = false;
	pass
	#restart()
	#for i in 500:
		#emit_particle(Transform2D(), Vector2(), Color(), Color(), 0)

func reset():
	immolation = 0.0
