extends Card
class_name AddEffectTarget

## Exported Variables
@export var effect: References.Effect # The effect to add

## Do Effect
func do_effect(card_target=null):
	if card_target:
		card_target.effects.append(effect)
