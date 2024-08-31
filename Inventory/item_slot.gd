extends Control

var item

var mouse_inside: bool = false

@export var equip_slot: bool = false

func _process(_delta):
	if mouse_inside:
		if !HoverBox.visible && item:
			HoverBox.reset()
			for affix in item.stone.affixes:
				HoverBox.add_line(affix.get_description())
			HoverBox.visible = true
		elif HoverBox.visible && !item:
			HoverBox.visible = false
	
func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false
	HoverBox.visible = false

func set_item(new_item):
	item = new_item
	add_child(new_item)
	if equip_slot:
		Inventory.equip_changed.emit(new_item.stone.affixes)

func pick_up_item():
	var tmp = item
	remove_child(item)
	item = null
	if equip_slot:
		Inventory.equip_changed.emit(tmp.stone.affixes)
	return tmp
	
func _on_gui_input(event):
	if event is InputEventMouseButton && event.pressed:
		if item:
			if Inventory.held_item.item:
				var held_item = Inventory.held_item.stop_holding()
				var slot_item = pick_up_item()
				Inventory.held_item.start_holding(slot_item)
				set_item(held_item)
			else:
				var slot_item = pick_up_item()
				Inventory.held_item.start_holding(slot_item)
		elif Inventory.held_item.item:
			var held_item = Inventory.held_item.stop_holding()
			set_item(held_item)
