extends EnemyCard
class_name SummonMinion

## Exported Variables
@export var minion_to_summon: PackedScene

## To be connected by the encounter
signal summon

## Do Effect
func do_effect(_card_target=null):
	summon.emit(minion_to_summon)
