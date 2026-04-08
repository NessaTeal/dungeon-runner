extends Resource
class_name Perk

@export var icon: Texture2D
@export var perk_name: String
@export var max_level: int = 1
@export var affixes: Array[BaseAffix]

@export_group("Perk dependencies")
@export var locks: Array[Perk]
@export var unlocks: Array[Perk]

@export_group("Costs (use 'level' as a scaling variable)")
@export_custom(PROPERTY_HINT_EXPRESSION, "10 + 2 * level") var apples_cost: String = "0"
@export_custom(PROPERTY_HINT_EXPRESSION, "10 + 2 * level") var grit_cost: String = "0"
@export_custom(PROPERTY_HINT_EXPRESSION, "10 + 2 * level") var souls_cost: String = "0"
@export_custom(PROPERTY_HINT_EXPRESSION, "10 + 2 * level") var vistas_cost: String = "0"

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NO_EDITOR) var _level: int

var unlocked_by: Array[Perk] = []
var locked_by: Array[Perk] = []
	
func get_description() -> String:
	return tr(perk_name.to_upper() + "_DESCRIPTION")

func increase_level() -> void:
	_level += 1
	for affix in affixes:
		affix._level += 1

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
	
	assert(expression.parse(vistas_cost, ["level"]) == OK)
	var vistas_result: int = expression.execute([_level])
	assert(not expression.has_execute_failed())
	perk_cost.vista_points = vistas_result
	
	return perk_cost
	
func _to_string() -> String:
	return "<Perk name=%s level=%d>" % [perk_name, _level]
