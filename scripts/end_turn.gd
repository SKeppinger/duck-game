extends TextureRect

signal end_player_turn

func _on_gui_input(event):
	if event.is_action_pressed("click"):
		end_player_turn.emit()
