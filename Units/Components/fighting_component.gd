extends Control
class_name FightingComponent

@export var attack_component: AttackComponent

var fighting = false
signal fight_started
signal fight_ended

func start_fight():
	fighting = true
	fight_started.emit()

func stop_fight():
	fighting = false
	fight_ended.emit()
