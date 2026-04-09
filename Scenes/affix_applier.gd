extends Node

@export var player: Player

func _ready() -> void:
	Utils.handled_connect(Inventory.equip_changed, apply_affixes)
	apply_affixes()

func get_all_affixes() -> Array[BaseAffix]:
	var all_affixes: Array[BaseAffix] = []
	for item in Inventory.get_equipment():
		all_affixes.append_array(item.stone.affixes)
	
	for perk_path in Meta.save_data.perk_levels.keys() as Array[String]:
		all_affixes.append_array(load(perk_path).affixes)
	
	return all_affixes
	
func apply_affixes() -> void:
	CurrentRunState.reset()
	for affix: BaseAffix in get_all_affixes():
		if affix is PlayerAffix:
			var player_affix := affix as PlayerAffix
			player_affix.player = player
			player_affix.apply()
		elif affix is RunAffix:
			var run_affix := affix as RunAffix
			run_affix.apply()
