extends Node3D
class_name ImmolationComponent

@export var immolation_damage := 0.0

@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var transformation_component: TransformationComponent
@export var timer: Timer

var immolation_emitter: PackedScene = preload("res://Units/Components/Immolation/immolation_emitter.tscn")

func _ready():
	Perks.affixes_changed.connect(_reset)
	_reset()

func _reset():
	var new_immolation_damage = Perks.get_total_affixes_power(ImmolationAffix)
	if immolation_damage != new_immolation_damage:
		immolation_damage = new_immolation_damage

func _on_timer_timeout() -> void:
	if immolation_damage > 0:
		transformation_component.transform("fire")
		var emitter := immolation_emitter.instantiate() as ImmolationEmitter
		emitter.immolation_damage = immolation_damage
		add_child(emitter)
