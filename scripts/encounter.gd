extends Control
class_name Encounter

## Exported Variables
@export var enemies: Array[Enemy] # The enemies in the encounter
@export var encounter_deck: Array[Card] # The encounter deck
@export var boss_encounter = false # Whether this is a boss encounter

## Children
@onready var enemy_box = $Enemies
@onready var boss_box = $EnemiesBoss
@onready var ducks_box = $Ducks

## Variables from Main Game
var ducks: Array[Duck] # The player's duck team
var player_deck: Array[Card] # The player's deck
var player_mana: Array[ManaPip] # The player's mana

## Other Variables
var minions: Array[Enemy] # Summoned minions

## Create an encounter
func _ready():
	# Show enemies
	for enemy in enemies:
		enemy.visible = true
	# Shuffle encounter deck
	encounter_deck.shuffle()

## Receive player info from the Main Game
func init_player(sent_ducks, sent_deck):
	var duck_count = 0
	for duck in sent_ducks:
		ducks.append(duck)
		duck_count += 1
		duck.copy_duck(ducks_box.get_node("Duck" + str(duck_count)))
	for card in sent_deck:
		player_deck.append(card)
	player_deck.shuffle()
