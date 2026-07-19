extends Node

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	
	var casted_event := event as InputEventKey
	
	if not casted_event.pressed:
		return
	
	if casted_event.keycode == Key.KEY_ESCAPE:
		get_tree().quit()
	elif casted_event.keycode == Key.KEY_9:
		if Collectible.apples == 0:
			Collectible.apples += 1
		else:
			Collectible.apples *= 2
		print("The apples are falling from dem clouds! Total apples: %d" % Collectible.apples)
	elif casted_event.keycode == Key.KEY_8:
		Collectible.grit += 1.0
		print("You feel more resolved! Total grit: %d" % Collectible.grit)
	elif casted_event.keycode == Key.KEY_7:
		Collectible.souls += 1
		print("Where did that come from? Total souls: %d" % Collectible.souls)
	elif casted_event.keycode == Key.KEY_1:
		Player.instance.health_component.receive_damage_no_emit(5.0)
	elif casted_event.keycode == Key.KEY_2:
		Player.instance.health_component.heal_damage(5.0)
		
