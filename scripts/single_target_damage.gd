extends Card
class_name SingleTargetDamage

## Exported Variables
@export var damage: int # The amount of damage the card deals
@export var reducible = false # Whether the damage can be reduced by defense

## Do Effect
func do_effect(card_target=null):
	if card_target:
		card_target.damage(damage, reducible)
