extends Node

var stored_immolation: float = 0
var player: Player
var game_state: GameState

func _ready():
	player = get_parent()
	game_state = player.game_state

func _on_timeout():
	if game_state.fighting:
		player.unit_attacking.emit(game_state.immolate * game_state.player_hp)
	elif game_state.immolate_storage > 0:
		stored_immolation = min(stored_immolation + game_state.immolate * game_state.player_hp, game_state.immolate_storage * game_state.player_hp)

func _on_encounter_started():
	if stored_immolation > 0:
		get_tree().create_timer(0.15).timeout.connect(func(): 
			player.unit_attacking.emit(stored_immolation)
			stored_immolation = 0
		)
