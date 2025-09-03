extends EnemyCard
class_name BlockableDamage

## Exported Variables
@export var damage: int # The amount of damage to assign

## To be connected by the encounter
signal blockable_damage

## Do Effect
func do_effect(_card_target=null):
	blockable_damage.emit(damage)
