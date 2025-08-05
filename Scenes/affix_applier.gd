extends Node

@export var player: Player

func _ready() -> void:
	Utils.handled_connect(Inventory.equip_changed, apply_affixes)
	for affix: BaseAffix in get_all_affixes():
		if affix is PlayerAffix:
			var player_affix := affix as PlayerAffix
			player_affix.player = player
			player_affix.apply()

func get_all_affixes() -> Array[BaseAffix]:
	var all_affixes: Array[BaseAffix] = []
	for item in Inventory.get_equipment():
		all_affixes.append_array(item.stone.affixes)
	
	for perk in Perks.active_perks.values() as Array[Perk]:
		all_affixes.append_array(perk.affixes)
	
	return all_affixes
	
func apply_affixes() -> void:
	player.reset()
	for affix: BaseAffix in get_all_affixes():
		if affix is PlayerAffix:
			var player_affix := affix as PlayerAffix
			player_affix.player = player
			player_affix.apply()
