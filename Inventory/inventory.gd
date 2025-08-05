extends PanelContainer

@export var grid: GridContainer
@export var equipment: Control
@export var held_item: HeldItem

var slots: Array[ItemSlot] = []

@warning_ignore("unused_signal")
signal equip_changed()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(18):
		var new_item_slot := preload("res://Inventory/item_slot.tscn").instantiate() as ItemSlot
		grid.add_child(new_item_slot)
		slots.push_back(new_item_slot)
		
	if !Engine.is_editor_hint():
		hide()

func add_item(new_item: Item) -> void:
	for slot in slots:
		if !slot.item:
			slot.set_item(new_item)
			return
	
	print("Inventory full")

func start_holding_item(new_item: Item) -> void:
	held_item.start_holding_item(new_item)
	
func stop_holding_item() -> Item:
	return held_item.stop_holding_item()

func get_equipment() -> Array[Item]:
	var items: Array[Item] = []
	for item_slot in equipment.get_children():
		if item_slot is ItemSlot:
			var item_slot_casted := item_slot as ItemSlot
			if item_slot_casted.item:
				items.push_back(item_slot_casted.item)
	return items

func _on_button_pressed() -> void:
	hide()
