extends ColorRect

@export var apple_count: Label
@export var grit_count: Label
@export var souls_count: Label
@export var perk_tree: PerkTree

var desired_scale = 1.0

func _enter_tree() -> void:
	# Debug values
	# To give resources when ran standalone
	if get_parent() == get_tree().root:
		Collectible.apples = 10000000
		Collectible.grit = 10000000
		Collectible.souls = 10000000

func _ready() -> void:
	apple_count.text = str(Collectible.apples)
	grit_count.text = str(floori(Collectible.grit))
	souls_count.text = str(Collectible.souls)

func _exit_tree() -> void:
	# Save game only if we are not in debug mode
	# Could cause troubles as it's very flaky check
	if get_parent() != get_tree().root:
		Meta.save_game()

func _on_button_pressed() -> void:
	queue_free()

func _on_perk_tree_perk_changed() -> void:
	apple_count.text = str(Collectible.apples)
	grit_count.text = str(floori(Collectible.grit))
	souls_count.text = str(Collectible.souls)

var dragging = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton click_event:
		if click_event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			dragging = click_event.pressed
		elif click_event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN && click_event.pressed:
			desired_scale = maxf(0.05, desired_scale / 1.2)
		elif click_event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP && click_event.pressed:
			desired_scale = minf(4.0, desired_scale * 1.2)
	elif dragging and event is InputEventMouseMotion motion_event:
		perk_tree.position += motion_event.relative

const SMOOTH_ZOOM_SPEED = 15.0

func _process(delta: float) -> void:
	var current_scale = perk_tree.scale.x
	var change_this_frame = (desired_scale - current_scale) * minf(1.0, delta * SMOOTH_ZOOM_SPEED)
	var next_scale = current_scale + change_this_frame
	var scale_factor = next_scale / current_scale
	perk_tree.scale = Vector2(next_scale, next_scale)
	perk_tree.position *= scale_factor
