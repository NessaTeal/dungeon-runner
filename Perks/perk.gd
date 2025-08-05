extends Resource
class_name Perk

@export var perk_name: String
@export var enabled: bool
@export var affixes: Array[BaseAffix]
@export var unlocks: Array[String]
@export var locks: Array[String]
var unlocked_by: Array[Perk] = []
var locked_by: Array[Perk] = []
var description: String

func _init(p_perk_name: String = "", p_enabled: bool = false, p_affixes: Array[BaseAffix] = [], p_unlocks: Array[String] = [], p_locks: Array[String] = []) -> void:
	perk_name = p_perk_name
	enabled = p_enabled
	affixes = p_affixes
	unlocks = p_unlocks
	locks = p_locks
	description = tr(p_perk_name.to_upper() + "_DESCRIPTION")
