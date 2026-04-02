extends Resource
class_name BaseAffix

@export var power := 100.0
@export var power_per_level := 0.0

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NO_EDITOR) var _level := 0
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NO_EDITOR) var _use_scaling := false

func get_scaled_power() -> float:
	assert(false, "To use scaling affix must implement get_scaled_power() using get_total_power()")
	return -1
	
func get_total_power() -> float:
	return power + power_per_level * maxi(_level - 1, 0)

func get_value() -> float:
	return get_scaled_power() if _use_scaling else get_total_power()

func apply() -> void:
	assert(false, "Affix must implement apply() which uses get_value()")

func get_description(level_up: bool = false) -> String:
	@warning_ignore("unsafe_cast")
	var perk_name := (get_script() as Script).get_path().split('/')[-1].split('.')[0].to_upper()
	var message := tr(perk_name + "_AFFIX_DESCRIPTION")
	
	if not message:
		return "TOOLTIP_IS_MISSING %s" % perk_name
	elif "%s" in message:
		var value := get_value()
		var string := "%s -> [color=green]%s[/color]" % [value, value + power_per_level] if level_up else str(value)
		return message % string
	else:
		return "TOOLTIP_MISSING_FORMATTING %s" % perk_name
