extends Card
class_name DamageAll

## Exported Variables
@export var damage: int # The amount of damage the card deals
@export var reducible = false # Whether the damage can be reduced by defense

## To be connected by the encounter
signal damage_all

## Do Effect
func do_effect(_card_target=null):
	damage_all.emit(damage, reducible)
