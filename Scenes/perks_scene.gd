extends ColorRect

@export var apple_count: Label
@export var perk_tree: PerkTree

func _ready() -> void:
	apple_count.text = str(Meta.collected_resources.apples)

func _on_button_pressed() -> void:
	queue_free()

func _on_perk_tree_perk_changed() -> void:
	apple_count.text = str(Meta.collected_resources.apples)

var dragging := false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var click_event := event as InputEventMouseButton
		if click_event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			dragging = click_event.pressed
		elif click_event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN && click_event.pressed:
			var cur_scale := perk_tree.scale.x
			cur_scale = maxf(0.05, cur_scale / 1.2)
			perk_tree.scale = Vector2(cur_scale, cur_scale)
		elif click_event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP && click_event.pressed:
			var cur_scale := perk_tree.scale.x
			cur_scale = minf(4.0, cur_scale * 1.2)
			perk_tree.scale = Vector2(cur_scale, cur_scale)
	elif dragging and event is InputEventMouseMotion:
		var motion_event := event as InputEventMouseMotion
		perk_tree.position += motion_event.relative
