extends GPUParticles2D
class_name ImmolationComponent

@export var immolation_damage = 10.0

@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var transformation_component: TransformationComponent
@export var _2d_component: Node2D

@onready var timer: Timer = $Timer

var immolation_collision: PackedScene = preload("res://Units/Components/Immolation/immolation_collision.tscn")

func _on_timeout():
	#amount_ratio += 0.01
	emitting = true;
	transformation_component.transform("fire")
	var new_collision = immolation_collision.instantiate()
	new_collision.immolation_damage = immolation_damage
	_2d_component.add_child(new_collision)
	#for enemy_collision in area.get_overlapping_areas() as Array[EnemyCollisionComponent]:
		#enemy_collision.receive_attack(immolation_damage)
	await get_tree().create_timer(0.05).timeout
	emitting = false;
	pass
	#restart()
	#for i in 500:
		#emit_particle(Transform2D(), Vector2(), Color(), Color(), 0)

func reset():
	immolation_damage = 10.0
