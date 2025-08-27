extends TextureRect
class_name Enemy

## Child References
@onready var name_label = $EnemyInfo/Name
@onready var hp_label = $EnemyInfo/HP

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
var effects: Array[Effect] # The enemy's currently active upgrades, debuffs, and other effects

## Initial Setup
func _ready():
	reset_stats()
	name_label.text = enemy_name
	hp_label.text = str(HP_actual) + "/" + str(HP)

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
