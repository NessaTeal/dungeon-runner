extends CanvasLayer

@export var hover_box: CenterContainer

@export var header: Label

@export var apple_count: Label
@export var grit_count: Label
@export var souls_count: Label
@export var vistas_count: Label

@export var apple_row: HBoxContainer
@export var grit_row: HBoxContainer
@export var souls_row: HBoxContainer
@export var vistas_row: HBoxContainer

@export var tips: VBoxContainer

@export var current_level: Label
@export var max_level: Label

const tooltip_line := preload("res://Perks/perks_tooltip_line.tscn")

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	hover_box.set_position(get_viewport().get_mouse_position() + Vector2(4, 0))

func reset() -> void:
	for child in tips.get_children():
		child.queue_free()

func add_line(text: String) -> void:
	var new_tooltip := tooltip_line.instantiate() as PerksTooltipLine
	new_tooltip.set_text(text)
	tips.add_child(new_tooltip)

func show_perk(perk: Perk) -> void:
	header.text = perk.get_description()
	current_level.text = str(perk._level)
	max_level.text = str(perk.max_level)
	
	var perk_cost := perk.get_perk_cost()
	
	apple_row.visible = perk_cost.apples > 0
	apple_count.text = str(perk_cost.apples)
	
	grit_row.visible = perk_cost.grit > 0
	grit_count.text = str(perk_cost.grit)
	
	souls_row.visible = perk_cost.souls > 0
	souls_count.text = str(perk_cost.souls)
	
	vistas_row.visible = perk_cost.culture > 0
	vistas_count.text = str(perk_cost.culture)
	
	for affix in perk.affixes:
		add_line(affix.get_description(perk._level != 0 && perk._level != perk.max_level))
	
