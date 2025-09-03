extends TextureRect
class_name Enemy

## Child References
@onready var name_label = $EnemyInfo/Name
@onready var hp_label = $EnemyInfo/HP
@onready var atk_label = $Attack/Num
@onready var def_label = $Defense/Num

## Stats
@export var ATK: int # The enemy's attack stat
@export var DEF: int # The enemy's defense stat
@export var HP: int # The enemy's health stat

## Info
@export var enemy_name: String # The enemy's name

## Actual Stats
var ATK_actual = ATK # The enemy's current attack stat
var DEF_actual = DEF # The enemy's current defense stat
var HP_actual = HP # The enemy's current HP

## Other
signal targeted # A signal to send when the enemy is clicked
signal died # A signal to send when the enemy dies
var can_target = false # Whether the enemy can currently be targeted
var effects: Array[References.Effect] # The enemy's currently active buffs and debuffs

## Initial Setup
func _ready():
	reset_stats()
	update_labels()

## On Click
func _on_click(event):
	if event.is_action_pressed("click"):
		if can_target:
			targeted.emit(self)

## Attack Target
func attack_target(target, reducible=true):
	target.damage(ATK_actual, reducible)

## Change Stat
func change_stat(stat, amount):
	match stat:
		References.Stat.ATK:
			ATK_actual += amount
		References.Stat.DEF:
			DEF_actual += amount
	update_labels()

## Heal
func heal(amount):
	HP_actual += amount
	if HP_actual > HP:
		HP_actual = HP
	update_labels()

## Damage
func damage(dmg, reducible=true):
	if reducible:
		dmg -= DEF_actual
	if dmg > 0:
		if References.Effect.Shield in effects:
			effects.erase(References.Effect.Shield)
			return
		HP_actual -= dmg
	if HP_actual <= 0:
		die()
	update_labels()

## Die
func die():
	visible = false
	died.emit(self)

## Start Target Phase
func start_target_phase():
	can_target = true
	mouse_default_cursor_shape = CursorShape.CURSOR_POINTING_HAND

## End Target Phase
func end_target_phase():
	can_target = false
	mouse_default_cursor_shape = CursorShape.CURSOR_ARROW

## Reset Stats
func reset_stats():
	reset_ATK()
	reset_DEF()
	reset_HP()

## Reset Attack
func reset_ATK():
	ATK_actual = ATK

## Reset Defense
func reset_DEF():
	DEF_actual = DEF

## Reset HP
func reset_HP():
	HP_actual = HP

## Update Labels
func update_labels():
	name_label.text = enemy_name
	hp_label.text = str(HP_actual) + "/" + str(HP)
	atk_label.text = str(ATK_actual)
	def_label.text = str(DEF_actual)
