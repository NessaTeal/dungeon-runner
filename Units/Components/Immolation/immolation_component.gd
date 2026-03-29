extends Node3D
class_name ImmolationComponent

@export var immolation_damage := 0.0

@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var transformation_component: TransformationComponent
@export var timer: Timer

var immolation_emitter: PackedScene = preload("res://Units/Components/Immolation/immolation_emitter.tscn")

func reset() -> void:
	immolation_damage = 0.0

func _on_timer_timeout() -> void:
	if immolation_damage > 0:
		transformation_component.transform("fire")
		var emitter := immolation_emitter.instantiate() as ImmolationEmitter
		emitter.immolation_damage = immolation_damage
		add_child(emitter)
