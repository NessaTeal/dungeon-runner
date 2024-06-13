extends Control

var item

var mouse_inside: bool = false

func _process(_delta):
	if mouse_inside:
		if !HoverBox.visible && item:
			HoverBox.reset()
			for affix in item.stone.get_children():
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

func pick_up_item():
	var tmp = item
	remove_child(item)
	item = null
	return tmp
	
func _on_gui_input(event):
	if event is InputEventMouseButton && event.pressed:
		if item:
			if HeldItem.item:
				var held_item = HeldItem.stop_holding()
				var slot_item = pick_up_item()
				HeldItem.start_holding(slot_item)
				set_item(held_item)
			else:
				var slot_item = pick_up_item()
				HeldItem.start_holding(slot_item)
		elif HeldItem.item:
			var held_item = HeldItem.stop_holding()
			set_item(held_item)
