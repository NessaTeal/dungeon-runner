extends Timer
class_name AttackComponent

@export var damage = 10

signal attack_happened(damage)

func _on_timeout():
	perform_attack(damage)

func perform_attack(attack_damage):
	attack_happened.emit(attack_damage)
