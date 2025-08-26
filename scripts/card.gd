extends TextureRect
class_name Card

## Signals
signal hover
signal unhover

## Variables
var selected = false # Whether the card is currently selected
var shifted = 0 # How many times the card has been shifted to the right
var rise_height = 30 # How high the card rises when hovered or selected
var shift_distance = 125 # How far the card is shifted to the right

## Shift right
func shift_right():
	if shifted < 2:
		shifted += 1
		position.x += shift_distance

## Shift left
func shift_left():
	if shifted > 0:
		shifted -= 1
		position.x -= shift_distance

## Show the card when moused over
func _on_mouse_entered():
	if not selected:
		z_index = 2
		position.y -= rise_height
		hover.emit(self)

## Return the card to its normal position
func _on_mouse_exited():
	if not selected:
		z_index = 0
		position.y += rise_height
		unhover.emit(self)
