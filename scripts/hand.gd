extends Control
class_name Hand

## Exported Variables
@export var cards_in_hand : Array[Card]

## Shift cards to the right when a card is hovered
func _on_card_hover(hovered):
	var found = false
	for card in cards_in_hand:
		if card == hovered:
			found = true
		elif found:
			card.shift_right()

## Shift cards to the left when a card is unhovered
func _on_card_unhover(unhovered):
	var found = false
	for card in cards_in_hand:
		if card == unhovered:
			found = true
		elif found:
			card.shift_left()
