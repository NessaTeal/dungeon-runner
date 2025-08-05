extends Control

@export var tips: VBoxContainer

const tooltip_line := preload("res://Perks/perks_tooltip_line.tscn")

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	set_position(get_viewport().get_mouse_position() + Vector2(16, 16))

func reset() -> void:
	for child in tips.get_children():
		child.queue_free()

func add_line(text: String) -> void:
	var new_tooltip := tooltip_line.instantiate() as PerksTooltipLine
	new_tooltip.set_text(text)
	tips.add_child(new_tooltip)
