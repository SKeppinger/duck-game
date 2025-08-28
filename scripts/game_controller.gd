extends Node
class_name MainGame

## TEMPORARY
@export var encounter: PackedScene
@export var ducks: Array[Duck]
@onready var deck = $Deck

## TEMPORARY
func _ready():
	var encounter_instance = encounter.instantiate()
	add_child(encounter_instance)
	encounter_instance.init_player(ducks, deck.get_children())
