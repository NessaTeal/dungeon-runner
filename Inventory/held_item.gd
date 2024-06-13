extends Control

var item

func _process(_delta):
	set_position(get_viewport().get_mouse_position())

func start_holding(new_item):
	item = new_item
	add_child(item)
	
func stop_holding():
	var tmp = item
	item = null
	remove_child(tmp)
	return tmp
