extends GPUParticles2D
class_name ImmolationComponent

var stored_immolation: float = 0
@export var immolation_storage_coefficient = 0.0
@export var immolation = 0.0

@export var fighting_component: FightingComponent
@export var health_component: HealthComponent
@export var attack_component: AttackComponent

@onready var timer: Timer = $Timer

func _on_timeout():
	if fighting_component.fighting:
		if immolation > 0:
			for i in 500:
				emit_particle(Transform2D(), Vector2(), Color(), Color(), 0)
			attack_component.perform_attack(immolation / 100 * health_component.max_hp)
			
	elif immolation_storage_coefficient > 0:
		stored_immolation = min(stored_immolation + immolation * health_component.max_hp, immolation_storage_coefficient * health_component.max_hp)

func _on_encounter_started():
	timer.start()
	if stored_immolation > 0:
		#emitting = true
		get_tree().create_timer(0.01).timeout.connect(func():
			attack_component.perform_attack(stored_immolation)
			stored_immolation = 0
		)
		
func _on_encounter_ended():
	emitting = false
	timer.stop()

func reset():
	immolation = 0.0
	immolation_storage_coefficient = 0.0
