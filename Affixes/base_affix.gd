extends Resource
class_name BaseAffix

@export var power := 100.0

func get_value() -> float:
	return -1337

func get_formatted_value() -> float:
	return get_value()

func apply() -> void:
	print("Affix not implemented")

func get_description() -> String:
	@warning_ignore("unsafe_cast")
	var perk_name := (get_script() as Script).get_path().split('/')[-1].split('.')[0].to_upper()
	var message := tr(perk_name + "_AFFIX_DESCRIPTION")
	
	if "%.1f" in message:
		return message % get_formatted_value()
	else:
		return "TOOLTIP_IS_MISSING %s" % perk_name

#func _init() -> void:
	
