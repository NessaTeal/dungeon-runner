extends MarginContainer
class_name HealthComponent

var damaged := 0.0
@export var max_hp := 50.0
@export var hp_regen := 0.0
@export var missing_hp_regen := 0.0

@export var health_bar: ProgressBar

signal hp_depleted
signal damage_received(damage: float)

func _ready() -> void:
	health_bar.max_value = max_hp
	health_bar.value = max_hp
	
func add_max_hp(extra_hp: float) -> void:
	max_hp += extra_hp
	health_bar.max_value = max_hp
	health_bar.value = max_hp

func _process(delta: float) -> void:
	damaged = maxf(0.0, damaged - (hp_regen * delta + (damaged) * missing_hp_regen * delta))
	health_bar.value = max_hp - damaged

func _on_receive_damage(damage: float) -> void:
	receive_damage_no_emit(damage)
	damage_received.emit(damage)
		
func receive_damage_no_emit(damage: float) -> void:
	damaged += damage
	health_bar.value = max(max_hp - damaged, 0)
	
	if damaged >= max_hp:
		hp_depleted.emit()
		
func heal_damage(heal: float) -> void:
	damaged = maxf(0.0, damaged - heal)
	health_bar.value = max_hp - damaged

#func scale_max_hp(factor: float) -> void:
	#base_hp *= factor
	#max_hp = base_hp
	#health_bar.max_value = base_hp
	#health_bar.value = base_hp

func reset() -> void:
	max_hp = 50.0
	hp_regen = 0.0
	missing_hp_regen = 0.0
