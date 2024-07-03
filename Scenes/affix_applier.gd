extends Node

@export var player: Player

func _ready():
	Inventory.equip_changed.connect(affixes_changed)
	for affix: BaseAffix in get_all_affixes():
		if affix.place_to_apply == BaseAffix.AFFIX_PLAYER:
			var component = player.components[affix.component];
			affix.apply(component)

func get_all_affixes():
	return Utils.flatmap(Inventory.slots.filter(func(slot): return slot.item), func(slot): return slot.item.stone.affixes)

func affixes_changed(affixes: Array[BaseAffix]):
	for affix in affixes:
		if affix.place_to_apply == BaseAffix.AFFIX_PLAYER:
			var component = player.components[affix.component];
			component.reset()
			get_all_affixes().filter(func(affix_internal): return affix_internal.component == affix.component).map(func(affix_internal): affix_internal.apply(component))
