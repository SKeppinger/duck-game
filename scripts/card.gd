extends TextureRect
class_name Card

## Signals
signal hover
signal unhover
signal dropped

## Exported Variables
@export var card_name: String # The name of the card
@export var target: References.TargetType # The card's target type

## Variables
var dragging = false # Whether the card is currently being dragged
var shifted = 0 # How many times the card has been shifted to the right
var rise_height = 30 # How high the card rises when hovered or selected
var shift_distance = 125 # How far the card is shifted to the right

## CARD MECHANICS

## VISUALS AND MOUSE
## Process (dragging cards)
func _process(_delta):
	if Input.is_action_pressed("click") and dragging:
		global_position = get_global_mouse_position()
		global_position.x -= texture.get_width() / 2.0
		global_position.y -= texture.get_height() / 2.0
	if not Input.is_action_pressed("click") and dragging:
		dropped.emit(self)
		dragging = false

## Start dragging card, send signal when dropped
func _gui_input(event):
	if event.is_action_pressed("click"):
		if get_parent() != get_tree().root:
			var tree = get_tree()
			get_parent().remove_child(self)
			tree.root.add_child(self)
			dragging = true

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
	z_index = 2
	position.y -= rise_height
	hover.emit(self)

## Return the card to its normal position
func _on_mouse_exited():
	z_index = 0
	position.y += rise_height
	unhover.emit(self)
