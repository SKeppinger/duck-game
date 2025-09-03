extends Card
class_name StatChangeAll

## Exported Variables
@export var stat: References.Stat # The stat to change
@export var amount: int # The amount to change it
@export var stat_target: References.TargetType # Whether to target ducks or enemies

## To be connected by the encounter
signal stat_change_all

## Do Effect
func do_effect(_card_target=null):
	stat_change_all.emit(stat_target, stat, amount)
