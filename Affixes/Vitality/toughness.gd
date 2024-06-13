extends BaseAffix

func get_value():
	return power * 2

func apply(game_state: GameState):
	game_state.player_hp += get_value()
