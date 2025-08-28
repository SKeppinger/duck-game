extends Control
class_name Encounter

## Exported Variables
@export var enemies: Array[PackedScene] # The enemies in the encounter
@export var encounter_deck: Array[Card] # The encounter deck
@export var boss_encounter = false # Whether this is a boss encounter
@export var neutral_mana: PackedScene # The neutral mana pip

## Children
@onready var enemy_box = $Enemies
@onready var boss_box = $EnemiesBoss
@onready var ducks_box = $Ducks
@onready var mana_box = $Mana
@onready var hand = $Hand/Cards
@onready var discard = $Discard
@onready var play_area = $PlayArea
@onready var mana_pips = $ManaPips

## Variables from Main Game
var ducks: Array[Duck] # The player's duck team
var player_deck: Array[Card] # The player's deck
var discard_pile: Array[Card] # The discard pile
var player_mana: Array[ManaPip] # The player's mana

## Other Variables
var states = References.EncounterState # The states enum
var state = states.StartPlayer # The current state
var cards_to_draw = 5 # How many cards the player draws each turn
var minions: Array[Enemy] # Summoned minions

## Process (Main Gameplay Loop)
func _process(_delta):
	match state:
		## PLAYER TURN
		# Start of player turn
		states.StartPlayer:
			state = states.Draw
		# Draw cards
		states.Draw:
			draw(cards_to_draw)
			state = states.Generate
		# Generate mana
		states.Generate:
			for duck in ducks:
				add_mana(duck.mana_generated)
			add_mana(neutral_mana)
			state = states.PlayerAction
		# Player actions
		states.PlayerAction:
			pass
		# Player chooses attack targets
		states.PlayerAttackTarget:
			pass
		# Player chooses card targets
		states.PlayerCardTarget:
			pass
		# End of player turn
		states.EndPlayer:
			pass
		## ENEMY TURN
		# Start of enemy turn
		states.StartEnemy:
			pass
		# Encounter deck cards
		states.EnemyCards:
			pass
		# Player blocks enemy attacks
		states.EnemyBlock:
			pass
		# Minion actions
		states.MinionAction:
			pass
		# Player blocks minion attacks
		states.MinionBlock:
			pass
		# End of enemy turn
		states.EndEnemy:
			pass

## Create an encounter
func _ready():
	# Show enemies
	var enemy_count = 0
	for enemy in enemies:
		var enemy_instance = enemy.instantiate()
		enemy_count += 1
		enemy_box.add_child(enemy_instance)
		enemy_instance.position = enemy_box.get_node("Enemy" + str(enemy_count)).position
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
		card.dropped.connect(dropped)
	player_deck.shuffle()

## Draw Cards
func draw(num):
	for i in range(num):
		var card = player_deck.pop_front()
		card.get_parent().remove_child(card)
		hand.add_child(card)
		card.visible = true

## Dropped Card
func dropped(card):
	if play_area.get_rect().has_point(get_global_mouse_position()):
		play(card)
	else:
		card.get_parent().remove_child(card)
		hand.add_child(card)

## Play Card
func play(card):
	## TODO: Card effects
	card.get_parent().remove_child(card)
	discard.add_child(card)
	discard_pile.append(card)

## Add Mana
func add_mana(mana_pip):
	var mana_instance = mana_pip.instantiate()
	mana_instance.visible = false
	mana_pips.add_child(mana_instance)
	player_mana.append(mana_instance)
	mana_box.update_display(player_mana)

## Remove Mana
# Returns true if the mana was removed, or false if there was no mana to remove
func remove_mana(color):
	for i in range(len(player_mana)):
		if player_mana[i].color == color:
			var pip = player_mana[i]
			player_mana.remove_at(i)
			pip.queue_free()
			mana_box.update_display(player_mana)
			return true
	return false
