extends TextureRect
class_name Duck

## Child References
@onready var name_label = $DuckInfo/Name
@onready var hp_label = $DuckInfo/HP

## Stats
@export var ATK: int # The duck's attack stat
@export var DEF: int # The duck's defense stat
@export var HP: int # The duck's health stat

## Info
@export var duck_name: String # The duck's name
@export var type: References.DuckType # The duck's type

## Actual Stats
var ATK_actual: int # The duck's current attack stat
var DEF_actual: int # The duck's current defense stat
var HP_actual: int # The duck's current HP

## Other
var effects: Array[Effect] # The duck's currently active upgrades, debuffs, and other effects
var tapped = false # Whether the duck is tapped

## Initial Setup
func _ready():
	reset_stats()
	name_label.text = duck_name
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

## Copy Duck
func copy_duck(target_duck):
	target_duck.ATK = ATK
	target_duck.DEF = DEF
	target_duck.HP = HP
	target_duck.ATK_actual = ATK_actual
	target_duck.DEF_actual = DEF_actual
	target_duck.HP_actual = HP_actual
	target_duck.duck_name = duck_name
	target_duck.type = type
	target_duck.effects = effects
	target_duck.tapped = tapped
	target_duck.name_label.text = duck_name
	target_duck.hp_label.text = str(HP_actual) + "/" + str(HP)
