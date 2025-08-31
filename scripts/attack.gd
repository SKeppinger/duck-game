extends EnemyCard
class_name EnemyAttack

signal enemy_attack

# Do Effect
func do_effect(_card_target=null):
	if _card_target:
		enemy_attack.emit()
