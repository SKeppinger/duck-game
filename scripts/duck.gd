extends TextureRect
class_name Duck

## Child References
@onready var name_label = $DuckInfo/Name

## Stats
@export var ATK: int # The duck's attack stat
@export var DEF: int # The duck's defense stat
@export var HP: int # The duck's health stat

## Info
@export var duck_name: String # The duck's name
@export var type: References.DuckType # The duck's type

## Other
var effects: Array[Effect] # The duck's currently active upgrades, debuffs, and other effects
var tapped = false # Whether the duck is tapped

## Copy Duck
func copy_duck(target_duck):
	target_duck.ATK = ATK
	target_duck.DEF = DEF
	target_duck.HP = HP
	target_duck.duck_name = duck_name
	target_duck.type = type
	target_duck.effects = effects
	target_duck.tapped = tapped
	target_duck.name_label.text = duck_name
