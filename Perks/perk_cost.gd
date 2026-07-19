extends Resource
class_name PerkCost

@export var apples: int
@export var grit: int
@export var souls: int
@export var culture: int

func can_afford() -> bool:
	return Collectible.apples >= apples		\
		and Collectible.grit >= grit		\
		and Collectible.souls >= souls		\
		and Collectible.culture >= culture
	
func pay() -> void:
	Collectible.apples -= apples
	Collectible.grit -= grit
	Collectible.souls -= souls
	Collectible.culture -= culture
	
func refund() -> void:
	Collectible.apples += apples
	Collectible.grit += grit
	Collectible.souls += souls
	Collectible.culture += culture

func get_save_data() -> Dictionary[String, int]:
	return {
		"apples": apples,
		"grit": grit,
		"souls": souls,
		"culture": culture
	}
