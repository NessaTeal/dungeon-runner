extends Node
class_name TransformationComponent

@export var sprite: AnimatedSprite3D

@onready var timer: Timer = $ResetTransformationTimer

func transform(form_name: String) -> void:
	var current_frame := sprite.get_frame()
	var current_progress := sprite.get_frame_progress()
	sprite.play(form_name)
	sprite.set_frame_and_progress(current_frame, current_progress)

	timer.start()

func reset_transform() -> void:
	transform("white")
