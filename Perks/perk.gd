extends Resource
class_name Perk

@export var icon: Texture2D
@export var perk_name: String
@export var max_level: int = 1
@export var elemental := false
@export var affixes: Array[BaseAffix]

#@export_group("Perk dependencies")
@export var unlocks: Array[Perk]
@export var locks: Array[Perk]

@export_group("Costs (use 'level' as a scaling variable)")
@export_custom(PROPERTY_HINT_EXPRESSION, "10 + 2 * level") var apples_cost: String = "0"
@export_custom(PROPERTY_HINT_EXPRESSION, "10 + 2 * level") var grit_cost: String = "0"
@export_custom(PROPERTY_HINT_EXPRESSION, "10 + 2 * level") var souls_cost: String = "0"
@export_custom(PROPERTY_HINT_EXPRESSION, "10 + 2 * level") var culture_cost: String = "0"

#@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NO_EDITOR) var _level: int:
var _level: int:
	set(value):
		for affix in affixes:
			affix._level = value
		_level = value

var unlocked_by: Array[Perk] = []

func set_unlocks() -> void:
	for unlocked_perk in unlocks:
		unlocked_perk.unlocked_by.push_back(self)
	
func get_description() -> String:
	return tr(perk_name.to_upper() + "_DESCRIPTION") + ("\nElemental pledge perk, you can only take limited amount.\nYou currently have %d/%d" % [Meta.save_data.get_elemental_perks_count(), Meta.save_data.elemental_limit]  if elemental else "")

func get_perk_cost() -> PerkCost:
	var perk_cost := PerkCost.new()
	var expression := Expression.new()
	
	assert(expression.parse(apples_cost, ["level"]) == OK)
	var apples_result: int = expression.execute([_level])
	assert(not expression.has_execute_failed())
	perk_cost.apples = apples_result
	
	assert(expression.parse(grit_cost, ["level"]) == OK)
	var grit_result: int = expression.execute([_level])
	assert(not expression.has_execute_failed())
	perk_cost.grit = grit_result
	
	assert(expression.parse(souls_cost, ["level"]) == OK)
	var souls_result: int = expression.execute([_level])
	assert(not expression.has_execute_failed())
	perk_cost.souls = souls_result
	
	assert(expression.parse(culture_cost, ["level"]) == OK)
	var culture_result: int = expression.execute([_level])
	assert(not expression.has_execute_failed())
	perk_cost.culture = culture_result
	
	return perk_cost
	
func _to_string() -> String:
	return "<Perk name=%s level=%d>" % [perk_name, _level]
