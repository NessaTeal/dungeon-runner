extends Node

class_name BaseAffix

enum {AFFIX_PLAYER, AFFIX_WORLD}

var power: int = 100
var place_to_apply = AFFIX_PLAYER
var component

func get_value():
	return -1337

func get_formatted_value():
	return get_value()

func apply(_actual_component):
	print("Affix not implemented")

func get_description():
	var perk_name = get_script().get_path().split('/')[-1].split('.')[0].to_upper()
	var message = tr(perk_name + "_AFFIX_DESCRIPTION")
	
	if "%.1f" in message:
		return message % get_formatted_value()
	else:
		return "TOOLTIP_IS_MISSING %s" % perk_name
