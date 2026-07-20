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

func format_value(value):
	return value

func get_dynamic_value() -> float:
	assert(false, "To use dynamic value affix must implement get_dynamic_value() which uses get_value() and register itself in apply() to a relevant component")
	return -1

func apply() -> void:
	assert(false, "Affix must implement apply() which uses get_value()")

func get_description(level_up: bool = false) -> String:
	@warning_ignore("unsafe_cast")
	var affix_script = get_script() as GDScript[BaseAffix]
	var affix_name = affix_script.get_path().split('/')[-1].split('.')[0].to_upper()
	var message = tr(affix_name + "_AFFIX_DESCRIPTION")
	
	var value = format_value(get_value())
	var leveled_value = format_value(get_value() + power_per_level)
	var should_show_leveled_value = level_up and value != leveled_value
	var string = "%s -> [color=green]%s[/color]" % [value, leveled_value] if should_show_leveled_value else str(value)
	return message.format([string])
