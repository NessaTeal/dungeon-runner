@tool
extends Control
class_name PerkBox

var perk_button: PerkButton

enum DIRECTION {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

var perk: Perk
var parent: PerkBox
var direction: DIRECTION
var distance := 0
var offset_vector: Vector2i

static var max_distance := -1

const OFFSET_DISTANCE := 250.0

func calculate_offset_vector() -> Vector2i:
	if not parent:
		return Vector2i.ZERO
	
	return OFFSET_VECTOR_MAPPINGS[direction] * (max_distance - distance + 1) + parent.offset_vector
		
static var OFFSET_VECTOR_MAPPINGS: Dictionary[DIRECTION, Vector2i] = {
	DIRECTION.UP: Vector2i(0, -1),
	DIRECTION.DOWN: Vector2i(0, 1),
	DIRECTION.RIGHT: Vector2i(1, 0),
	DIRECTION.LEFT: Vector2i(-1, 0)
}

static var OPPOSITE_DIRECTIONS: Dictionary[DIRECTION, DIRECTION] = {
	DIRECTION.UP: DIRECTION.DOWN,
	DIRECTION.DOWN: DIRECTION.UP,
	DIRECTION.RIGHT: DIRECTION.LEFT,
	DIRECTION.LEFT: DIRECTION.RIGHT
}

func get_offset_position() -> Vector2:
	return Vector2(offset_vector) * OFFSET_DISTANCE
	
var children_boxes: Array[PerkBox] = []

func _enter_tree() -> void:
	perk_button = $PerkButton
	perk_button.perk_resource = perk

func _ready() -> void:
	max_distance = maxi(distance, max_distance)

func update_position() -> void:
	offset_vector = calculate_offset_vector()
	if parent:
		position = get_offset_position()
		var line_trust_me := ColorRect.new()
		line_trust_me.size = (position - parent.position).abs() + Vector2(20, 20)
		if direction == DIRECTION.DOWN or direction == DIRECTION.RIGHT:
			line_trust_me.position = -line_trust_me.size + Vector2(10, 10)
		else:
			line_trust_me.position -= Vector2(10, 10)
		line_trust_me.color = Color(randf(), randf(), randf(), 1)
		line_trust_me.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(line_trust_me)
	
	for child in children_boxes:
		child.update_position()
	
