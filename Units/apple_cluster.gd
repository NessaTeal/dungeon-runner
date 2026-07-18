extends Node3D
class_name AppleCluster

@export var cluster_size = 3

var apples_remaining = 0

const CLUSTER_SPREAD = 1

func _ready() -> void:
	apples_remaining = cluster_size
	for i in cluster_size:
		var apple = Asset.Instantiate(Apple)
		add_child(apple)
		apple.position = Vector3(randf_range(-CLUSTER_SPREAD, CLUSTER_SPREAD), 0, randf_range(-CLUSTER_SPREAD, CLUSTER_SPREAD))
		apple.picked_up.connect(func() -> void:
			apples_remaining -= 1
			if apples_remaining <= 0:
				queue_free()
		)
