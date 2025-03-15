extends GPUParticles2D
class_name ImmolationComponent

@export var immolation = 0.0

@export var health_component: HealthComponent
@export var attack_component: AttackComponent

@onready var timer: Timer = $Timer

func _on_timeout():
	if immolation > 0:
		for i in 500:
			emit_particle(Transform2D(), Vector2(), Color(), Color(), 0)
		attack_component.perform_attack(immolation / 100 * health_component.max_hp)
			
	#elif immolation_storage_coefficient > 0:
		#stored_immolation = min(stored_immolation + immolation * health_component.max_hp, immolation_storage_coefficient * health_component.max_hp)

func reset():
	immolation = 0.0
