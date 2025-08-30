extends TextureRect
class_name EnemyCard

## Exported Variables
@export var card_name: String # The name of the card
@export var card_type: References.CardType # The card's type
@export var target: References.TargetType # The card's target type
@export var traits: Array[References.Trait] # The card's traits

## Do Effect - this function will be overridden by the card's child class
func do_effect(_card_target=null):
	pass
