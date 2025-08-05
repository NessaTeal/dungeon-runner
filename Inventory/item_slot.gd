extends Control
class_name ItemSlot

var item: Item
var mouse_inside := false

@export var equip_slot := false

func _process(_delta: float) -> void:
	if mouse_inside:
		if !HoverBox.visible && item:
			HoverBox.reset()
			for affix in item.stone.affixes:
				HoverBox.add_line(affix.get_description())
			HoverBox.visible = true
		elif HoverBox.visible && !item:
			HoverBox.visible = false
	
func _on_mouse_entered() -> void:
	mouse_inside = true

func _on_mouse_exited() -> void:
	mouse_inside = false
	HoverBox.visible = false

func set_item(new_item: Item) -> void:
	item = new_item
	add_child(new_item)
	if equip_slot:
		Inventory.equip_changed.emit()

func pick_up_item() -> Item:
	var tmp := item
	remove_child(item)
	item = null
	if equip_slot:
		Inventory.equip_changed.emit()
	return tmp
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		if mouse_button_event.pressed:
			if item:
				if Inventory.held_item.item:
					var held_item: Item = Inventory.stop_holding_item()
					var slot_item := pick_up_item()
					Inventory.start_holding_item(slot_item)
					set_item(held_item)
				else:
					var slot_item := pick_up_item()
					Inventory.start_holding_item(slot_item)
			elif Inventory.held_item.item:
				var held_item: Item = Inventory.stop_holding_item()
				set_item(held_item)
