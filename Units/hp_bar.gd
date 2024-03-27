extends Control

class_name HPBar

@onready var hp_bar: ColorRect = $"HP bar"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_unit_hp_updated(current_hp, max_hp):
	hp_bar.set_size(Vector2(384 * current_hp / max_hp, 40))
