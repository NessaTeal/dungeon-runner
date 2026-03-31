extends Resource
class_name BaseAffix

@export var power := 100.0
@export var power_per_level := 0.0
@export var raw_power := 0.0
@export var raw_power_per_level := 0.0
@export var level := 0

func get_power() -> float:
	return power + level * power_per_level

func get_scaled_power() -> float:
	return -1337

func get_value() -> float:
	return raw_power + level * raw_power_per_level if raw_power > 0 else get_scaled_power()

func get_formatted_value() -> float:
	return get_value()

func get_one_level_power() -> float:
	return raw_power_per_level if raw_power_per_level else power_per_level

func apply() -> void:
	print("Affix not implemented")

func get_description(level_up: bool = false) -> String:
	@warning_ignore("unsafe_cast")
	var perk_name := (get_script() as Script).get_path().split('/')[-1].split('.')[0].to_upper()
	var message := tr(perk_name + "_AFFIX_DESCRIPTION")
	
	if not message:
		return "TOOLTIP_IS_MISSING %s" % perk_name
	elif "%s" in message:
		var string := "%s -> [color=green]%s[/color]" % [get_formatted_value(), get_formatted_value() + get_one_level_power()] if level_up else str(get_formatted_value())
		return message % string
	else:
		return "TOOLTIP_MISSING_FORMATTING %s" % perk_name
