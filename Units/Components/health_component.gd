extends MarginContainer
class_name HealthComponent

var damaged = 0.0
@export var base_max_hp = 50.0
var max_hp = 0.0:
	set(value):
		max_hp = value
		health_bar.max_value = max_hp
@export var hp_regen = 0.0
@export var missing_hp_regen = 0.0

@export var health_bar: ProgressBar

signal hp_depleted
signal damage_received(damage: float)

func _ready() -> void:
	Perks.affixes_changed.connect(_reset)
	_reset()
	health_bar.value = max_hp

func _reset():
	var new_max_hp = base_max_hp + Perks.get_total_affixes_power(ToughnessAffix)
	if max_hp != new_max_hp:
		max_hp = new_max_hp
		
	var new_hp_regen = Perks.get_total_affixes_power(HPRegenAffix)
	if hp_regen != new_hp_regen:
		hp_regen = new_hp_regen

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

func get_health_percentage() -> float:
	return (max_hp - damaged) / max_hp

#func scale_max_hp(factor: float) -> void:
	#base_hp *= factor
	#max_hp = base_hp
	#health_bar.max_value = base_hp
	#health_bar.value = base_hp
