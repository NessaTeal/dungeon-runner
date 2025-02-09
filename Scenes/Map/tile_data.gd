extends RefCounted

var sockets
var atlas_position

func _init(sockets, atlas_position) -> void:
	self.sockets = sockets
	self.atlas_position = atlas_position

func check_socket(socket1: String, socket2: String):
	return socket1 == socket2.reverse()
