extends Resource
class_name PerkCost

@export var apples: int
@export var grit: int
@export var souls: int
@export var vista_points: int

func can_afford() -> bool:
	return Meta.collected_resources.apples >= apples && Meta.collected_resources.grit >= grit && Meta.collected_resources.souls >= souls && Meta.collected_resources.vista_points >= vista_points
	
func pay() -> void:
	Meta.collected_resources.apples -= apples
	Meta.collected_resources.grit -= grit
	Meta.collected_resources.souls -= Meta.collected_resources.souls
	Meta.collected_resources.vista_points -= vista_points
	Meta.save_collected_resources()

func get_save_data() -> Dictionary[String, Variant]:
	return {
		"apples": apples,
		"grit": grit,
		"souls": souls,
		"vista_points": vista_points
	}
