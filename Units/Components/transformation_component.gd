extends Node
class_name TransformationComponent

@export var sprite: AnimatedSprite2D

@onready var timer: Timer = $ResetTransformationTimer

func transform(form_name: String):
	var current_frame = sprite.get_frame()
	var current_progress = sprite.get_frame_progress()
	sprite.play(form_name)
	sprite.set_frame_and_progress(current_frame, current_progress)

	timer.start()

func reset_transform():
	transform("white")
