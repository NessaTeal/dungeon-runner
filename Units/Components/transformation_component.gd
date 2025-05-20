extends Node
class_name TransformationComponent

@export var player: Player

@onready var timer: Timer = $ResetTransformationTimer

func transform(form_name: String):
	var current_frame = player.get_frame()
	var current_progress = player.get_frame_progress()
	player.play(form_name)
	player.set_frame_and_progress(current_frame, current_progress)

	timer.start()

func reset_transform():
	transform("white")
