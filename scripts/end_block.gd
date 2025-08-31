extends TextureRect

signal end_block

func _on_gui_input(event):
	if event.is_action_pressed("click"):
		end_block.emit()
