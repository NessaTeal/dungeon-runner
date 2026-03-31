extends Resource
class_name Perk

@export var icon: Texture2D
@export var perk_name: String
@export var level: int
@export var max_level: int = 1
@export var affixes: Array[BaseAffix]
@export var unlocks: Array[Perk]
@export var locks: Array[Perk]
@export var cost: PerkCost
var unlocked_by: Array[Perk] = []
var locked_by: Array[Perk] = []
	
func get_description() -> String:
	return tr(perk_name.to_upper() + "_DESCRIPTION")

func bump_level() -> void:
	level += 1
	for affix in affixes:
		affix.level += 1
