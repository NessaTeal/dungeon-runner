extends ProgressBar
class_name AttackComponent

@export var base_damage = 10
@export var base_attack_speed = 100
@export var fighting_component: FightingComponent
var affix_damage = 0
var affix_attack_speed = 0
var dynamic_damage = []
var dynamic_attack_speed = []
var count_up = 0

var damage:
	get:
		return base_damage + affix_damage + Utils.reduce(dynamic_damage, func(acc, cur): return acc + cur.get_value(), 0)

var attack_speed:
	get:
		return base_attack_speed + affix_attack_speed
		
var multiplier = 1

signal attack_happened(damage)

func _process(delta):
	if fighting_component.fighting:
		count_up += delta * attack_speed
		value = count_up
		while count_up >= 100:
			count_up -= 100
			perform_attack(damage)

func perform_attack(attack_damage):
	if attack_damage <= 0:
		print("Illegal attack")
		print(get_stack())
	attack_happened.emit(attack_damage * multiplier)

func reset():
	affix_damage = 0
	affix_attack_speed = 0
	multiplier = 1

func reset_bar():
	count_up = 0
	value = 0
