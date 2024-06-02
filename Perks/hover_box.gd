extends Control

@onready var tips = $MarginContainer/VBoxContainer2/VBoxContainer
@onready var header = $MarginContainer/VBoxContainer2/Header

var tooltip_line = preload("res://Perks/perks_tooltip_line.tscn")

func _ready():
	visible = false

func _process(_delta):
	set_position(get_viewport().get_mouse_position() + Vector2(16, 16))

func reset():
	for child in tips.get_children():
		child.free()

func add_line(text: String):
	var new_tooltip = tooltip_line.instantiate()
	new_tooltip.get_node("HBoxContainer/Label").text = text
	tips.add_child(new_tooltip)
