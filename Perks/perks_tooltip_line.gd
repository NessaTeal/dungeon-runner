extends MarginContainer
class_name PerksTooltipLine

@export var label: RichTextLabel

func set_text(text: String) -> void:
	label.text = text
