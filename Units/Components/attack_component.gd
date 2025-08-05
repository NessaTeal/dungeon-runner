extends Node
class_name AttackComponent

@export var base_damage := 10.0
@export var base_attack_speed := 100.0

var affix_damage := 0.0
var affix_attack_speed := 0.0
var dynamic_damage: Array[ValueComponent] = []
var dynamic_attack_speed: Array[ValueComponent] = []
var count_up := 0.0

var damage: float:
	get:
		return base_damage + affix_damage + dynamic_damage.reduce(func(acc: float, cur: ValueComponent) -> float: return acc + cur.get_value(), 0.0)

var attack_speed: float:
	get:
		return base_attack_speed + affix_attack_speed
		
var multiplier := 1.0

signal attack_happened(damage: float)

func _process(delta: float) -> void:
	count_up += delta * attack_speed
	while count_up >= 100:
		count_up -= 100
		perform_attack(damage)

func perform_attack(attack_damage: float) -> void:
	attack_happened.emit(attack_damage * multiplier)

func reset() -> void:
	affix_damage = 0
	affix_attack_speed = 0
	multiplier = 1
