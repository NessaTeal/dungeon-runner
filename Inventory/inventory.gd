extends Control

@export var item_slot = preload("res://Inventory/item_slot.tscn") 
@onready var grid = $GridContainer

var slots: Array = []

signal equip_changed(affixes: Array[BaseAffix])
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(18):
		var new_item_slot = item_slot.instantiate()
		grid.add_child(new_item_slot)
		slots.push_back(new_item_slot)

func add_item(new_item):
	var free_slot = Utils.first_element_which(slots, func(slot): return !slot.item)
	if !free_slot:
		print("Inventory full")
		return
	free_slot.set_item(new_item)
