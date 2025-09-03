extends Card
class_name SingleTargetHeal

## Exported Variables
@export var heal_amount: int # The amount to heal

## Do Effect
func do_effect(card_target=null):
	if card_target:
		card_target.heal(heal_amount)
