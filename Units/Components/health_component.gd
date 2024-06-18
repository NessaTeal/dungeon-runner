extends ProgressBar
class_name HealthComponent

var hp = 0
@export var max_hp = 0
@export var hp_regen = 0
@export var missing_hp_regen = 0

signal hp_depleted

func _ready():
	hp = max_hp
	self.max_value = max_hp
	self.value = max_hp

func _process(delta):
	hp = min(max_hp, hp + hp_regen * delta + (max_hp - hp) * missing_hp_regen * delta)
	self.value = hp

func _on_receive_damage(damage):
	hp -= damage
	self.value = max(hp, 0)
	
	if hp <= 0:
		hp_depleted.emit()

func scale_max_hp(factor):
	max_hp *= factor
	hp = max_hp
	self.max_value = max_hp
	self.value = hp
