extends Node
class_name PerformanceUtils

func _ready():
	print("%s: %.2f ms"%["[init] Engine startup", Time.get_ticks_usec() / 1000.0])
	var timer = startMeasure("[init] Scene tree ready")
	await get_tree().process_frame
	timer.endMeasure()

class ProfileTimer:
	var label: String
	var startedAt: float

	func endMeasure():
		var duration = Time.get_ticks_usec() - startedAt
		print("%s: %.2f ms"%[label, duration / 1000.0])

static func startMeasure(label: String) -> ProfileTimer:
	var timer = ProfileTimer.new()
	timer.label = label
	timer.startedAt = Time.get_ticks_usec()
	return timer
