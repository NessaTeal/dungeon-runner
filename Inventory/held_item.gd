extends Control
class_name HeldItem

var item: Item

func _process(_delta: float) -> void:
	set_global_position(get_viewport().get_mouse_position())

func start_holding_item(new_item: Item) -> void:
	item = new_item
	add_child(item)
	
func stop_holding_item() -> Item:
	var tmp := item
	item = null
	remove_child(tmp)
	return tmp
