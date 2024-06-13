extends Node

class_name BaseAffix

var power: int = 100

func get_value():
	return -1337
	
func apply(_game_state: GameState):
	pass

func get_description():
	var perk_name = get_script().get_path().split('/')[-1].split('.')[0].to_upper()
	var message = tr(perk_name + "_AFFIX_DESCRIPTION")
	
	if "%.1f" in message:
		return message % get_value()
	else:
		return "TOOLTIP_IS_MISSING %s" % perk_name
