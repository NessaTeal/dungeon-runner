extends ProgressBar
class_name HealthComponent

var damaged = 0
@export var base_hp = 0.0
var max_hp = 0
@export var base_hp_regen = 0
var hp_regen = 0
@export var missing_hp_regen = 0

signal hp_depleted
signal damage_received(damage)

func _ready():
	self.max_value = base_hp
	self.value = base_hp
	max_hp = base_hp
	hp_regen = base_hp_regen

func _process(delta):
	damaged = max(0, damaged - (hp_regen * delta + (damaged) * missing_hp_regen * delta))
	self.value = max_hp - damaged

func _on_receive_damage(damage):
	damaged += damage
	damage_received.emit(damage)
	self.value = max(max_hp - damaged, 0)
	
	if damaged >= max_hp:
		hp_depleted.emit()

func scale_max_hp(factor: float):
	base_hp *= factor
	max_hp = base_hp
	self.max_value = base_hp
	self.value = base_hp

func reset():
	max_hp = base_hp
	self.max_value = max_hp
	hp_regen = base_hp_regen
	missing_hp_regen = 0
