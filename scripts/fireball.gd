extends DamageAll
class_name Fireball

## Exported Variables
@export var damage_to_ducks: int # Damage to ducks
@export var hurt_chance: float # Chance to hurt ducks

## To be connected by the encounter
signal damage_all_ducks

## Do Effect
func do_effect(_card_target=null):
	super.do_effect()
	var roll = randf()
	if roll <= hurt_chance:
		damage_all_ducks.emit(damage_to_ducks, reducible)
