extends Control
class_name FightingComponent

@export var attack_component: AttackComponent

var fighting = false

func start_fight():
	fighting = true
	attack_component.start()

func stop_fight():
	fighting = false
	attack_component.stop()
