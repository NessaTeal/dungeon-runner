extends BaseComponent
class_name SpeedComponent

@export var core_speed = 4.0
var base_speed = 0.0
var current_speed = 0.0

var distance = 0.0
var fight_speed = 0.0
var acceleration = 0.0
var speed_from_acceleration = 0.0
var speed_boost_halflife = 0.2
var current_speed_boost = 0.0
var boost_per_apple = 0.0

func _ready():
	Perks.affixes_changed.connect(_reset)
	_reset()
	
func _reset():
	var new_speed = core_speed + Perks.get_total_affixes_power(MoveSpeedAffix)
	if base_speed != new_speed:
		base_speed = new_speed
	
	var new_damaged_speed = Perks.get_total_affixes_power(DamagedSpeedAffix)
	if get_base_value_for_affix(DamagedSpeedAffix) != new_damaged_speed:
		dynamic_affixes.set(DamagedSpeedAffix, Perks.get_all_affixes_of_class(DamagedSpeedAffix))
		
	var new_boost_per_apple = Perks.get_total_affixes_power(AppleBoostAffix)
	if boost_per_apple != new_boost_per_apple:
		boost_per_apple = new_boost_per_apple

func _process(delta: float) -> void:
	distance += get_current_speed() * delta
	speed_from_acceleration += acceleration * delta
	current_speed_boost *= exp(-delta/speed_boost_halflife)

func get_current_speed() -> float:
	return current_speed + speed_from_acceleration + get_dynamic_value() + current_speed_boost
