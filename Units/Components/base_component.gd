extends Control
class_name BaseComponent

var dynamic_affixes: Dictionary[GDScript[BaseAffix], Array[BaseAffix]] = {}

func get_dynamic_value() -> float:
	var values_per_key: Dictionary[GDScript[BaseAffix], float] = get_dynamic_values_per_key()
	
	return values_per_key.values().reduce(func(acc: float, cur: float) -> float: return acc + cur, 0.0)
	
	#var keys: Array[String] = sources.keys()
	#for key in keys:
		#var affixes = sources[key]
		#var key_sum = affixes.reduce(func(acc: float, affix: BaseAffix) -> float: return acc + get_dynamic_value(), 0.0)
	
	#return sources.values().map(func(affixes: Array[BaseAffix]) -> float: return affixes.reduce(func(sum: float, affix: BaseAffix) -> float: return sum + get_dynamic_value(), 0.0))

func get_dynamic_values_per_key() -> Dictionary[GDScript[BaseAffix], float]:
	var values_per_key: Dictionary[GDScript[BaseAffix], float] = {}
	
	var keys: Array[GDScript[BaseAffix]] = dynamic_affixes.keys()
	for key in keys:
		var affixes = dynamic_affixes[key]
		var key_sum: float = affixes.reduce(func(acc: float, affix: BaseAffix) -> float: return acc + affix.get_dynamic_value(), 0.0)
		values_per_key[key] = key_sum
		
	return values_per_key

func get_base_value_for_affix(affix_class: GDScript[BaseAffix]) -> float:
	if not dynamic_affixes.has(affix_class):
		return 0
	
	return dynamic_affixes[affix_class].reduce(func(acc: float, affix: BaseAffix) -> float: return acc + affix.get_value(), 0.0)

func add_dynamic_affix(key: GDScript[BaseAffix], affix: BaseAffix) -> void:
	if dynamic_affixes.has(key):
		dynamic_affixes[key].push_back(affix)
	else:
		dynamic_affixes[key] = [affix]
