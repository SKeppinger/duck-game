extends Control
class_name Encounter

## Exported Variables
@export var enemy_scenes: Array[PackedScene] # The enemies in the encounter
@export var encounter_deck: Array[EnemyCard] # The encounter deck
@export var boss_encounter = false # Whether this is a boss encounter
@export var neutral_mana: PackedScene # The neutral mana pip
@export var difficulty = 0 # The encounter's difficulty (affects how many enemy cards are played)

## Children
@onready var enemy_box = $Enemies
@onready var boss_box = $EnemiesBoss
@onready var ducks_box = $Ducks
@onready var mana_box = $Mana
@onready var hand = $Hand/Cards
@onready var discard_icon = $Discard
@onready var play_area = $PlayArea
@onready var mana_pips = $ManaPips
@onready var end_button = $EndTurn
@onready var end_block_button = $EndBlock

## Variables from Main Game
var ducks: Array[Duck] # The player's duck team
var enemies: Array[Enemy] # The enemies
var player_deck: Array[Card] # The player's deck
var discard_pile: Array[Card] # The discard pile
var player_mana: Array[ManaPip] # The player's mana

## Other Variables
var deck_node = null # The deck node
var encounter_discard: Array[EnemyCard] # The used enemy cards
var states = References.EncounterState # The states enum
var state = states.StartPlayer # The current state
var cards_to_draw = 5 # How many cards the player draws each turn
var minions: Array[Enemy] # Summoned minions (INCLUDED in enemies array as well)
var action_phase_started = false # Whether the action phase has been started
var target_phase_started = false # Whether the target phase has been started
var block_phase_started = false # Whether the block phase has been started
var attacker = null # The current attacker
var caster = null # The current caster
var current_card = null # The current card being played
var current_enemy = null # The current enemy playing a card
var current_enemy_target = null # The enemy's current target
var enemy_cards_played = 0 # The number of enemy cards played this turn
var enemy_cards_to_play = 0 # The number of enemy cards to play this turn

## Process (Main Gameplay Loop)
func _process(_delta):
	match state:
		## PLAYER TURN
		# Start of player turn
		states.StartPlayer:
			for duck in ducks:
				duck.untap()
			state = states.Draw
		# Draw cards
		states.Draw:
			draw(cards_to_draw)
			state = states.Generate
		# Generate mana
		states.Generate:
			for duck in ducks:
				add_mana(duck.mana_generated, 1)
			add_mana(neutral_mana, 3) ##TODO: this amount depends on the duck team
			end_button.visible = true
			state = states.PlayerAction
		# Player actions
		states.PlayerAction:
			end_button.visible = true
			if not action_phase_started:
				for duck in ducks:
					duck.start_action_phase()
				action_phase_started = true
		# Player chooses attack targets
		states.PlayerAttackTarget:
			end_button.visible = false
			if not target_phase_started:
				for enemy in enemies:
					enemy.start_target_phase()
				target_phase_started = true
		# Player chooses card targets
		states.PlayerCardTarget:
			end_button.visible = false
			if not target_phase_started:
				match current_card.target:
					References.TargetType.Enemy:
						for enemy in enemies:
							enemy.start_target_phase()
						target_phase_started = true
					References.TargetType.Duck:
						for duck in ducks:
							duck.start_target_phase()
						target_phase_started = true
		# End of player turn
		states.EndPlayer:
			for duck in ducks:
				duck.reset_ATK()
				duck.reset_DEF()
			action_phase_started = false
			for card in hand.get_children():
				discard(card)
			end_button.visible = false
			empty_mana()
			state = states.StartEnemy
		## ENEMY TURN
		# Start of enemy turn
		states.StartEnemy:
			state = states.EnemyCards
		# Encounter deck cards
		states.EnemyCards:
			if enemy_cards_played == 0:
				enemy_cards_to_play = difficulty + len(enemies) - len(minions)
			if enemy_cards_played == enemy_cards_to_play:
				enemy_cards_played = 0
				state = states.MinionAction
			if encounter_deck.is_empty():
				for card in encounter_discard:
					encounter_deck.append(card)
				encounter_discard.clear()
				encounter_deck.shuffle()
			var drawn_card = encounter_deck.pop_front()
			current_enemy = enemies[enemy_cards_played]
			match drawn_card.target:
				References.TargetType.Duck:
					current_enemy_target = ducks[randi_range(0, len(ducks) - 1)]
				References.TargetType.Enemy:
					current_enemy_target = enemies[randi_range(0, len(enemies) - len(minions) - 1)]
			print("enemies play " + drawn_card.card_name + " on " + current_enemy_target.duck_name)
			enemy_cards_played += 1
			encounter_discard.append(drawn_card)
			drawn_card.do_effect(current_enemy_target)
		# Player blocks enemy attacks
		states.EnemyBlock:
			end_block_button.visible = true
			if not block_phase_started:
				for duck in ducks:
					duck.start_block_phase()
				block_phase_started = true
		# Minion actions
		states.MinionAction:
			state = states.MinionBlock
		# Player blocks minion attacks
		states.MinionBlock:
			state = states.EndEnemy
		# End of enemy turn
		states.EndEnemy:
			for enemy in enemies:
				enemy.reset_ATK()
				enemy.reset_DEF()
			state = states.StartPlayer

## Create an encounter
func _ready():
	# Show enemies
	var enemy_count = 0
	for enemy in enemy_scenes:
		var enemy_instance = enemy.instantiate()
		enemy_count += 1
		enemy_box.add_child(enemy_instance)
		enemy_instance.position = enemy_box.get_node("Enemy" + str(enemy_count)).position
		enemy_instance.targeted.connect(_on_enemy_targeted)
		enemies.append(enemy_instance)
	# Shuffle encounter deck
	for card in encounter_deck:
		if card is EnemyAttack:
			card.enemy_attack.connect(enemy_attack)
	encounter_deck.shuffle()

## Receive player info from the Main Game
func init_player(sent_ducks, sent_deck):
	var duck_count = 0
	for duck in sent_ducks:
		duck_count += 1
		duck.copy_duck(ducks_box.get_node("Duck" + str(duck_count)))
		ducks.append(ducks_box.get_node("Duck" + str(duck_count)))
	deck_node = sent_deck
	for card in sent_deck.get_children():
		player_deck.append(card)
		card.dropped.connect(dropped)
		if card is DamageAll:
			card.damage_all.connect(damage_all)
			if card is Fireball:
				card.damage_all_ducks.connect(damage_all_ducks)
		if card is StatChangeAll:
			card.stat_change_all.connect(stat_change_all)
	player_deck.shuffle()

## Draw Cards
func draw(num):
	for i in range(num):
		if player_deck.is_empty():
			if discard_pile.is_empty():
				return
			refill()
		var card = player_deck.pop_front()
		card.get_parent().remove_child(card)
		hand.add_child(card)
		card.visible = true

## Dropped Card
func dropped(card):
	if state == states.PlayerAction and play_area.get_rect().has_point(get_global_mouse_position()):
		play(card)
	else:
		card.get_parent().remove_child(card)
		hand.add_child(card)

## Play Card
func play(card):
	var cost_met = 0
	var mana_to_pay = []
	for mana in player_mana:
		if cost_met < card.cost and mana.color == card.color:
			cost_met += 1
			mana_to_pay.append(mana.color)
	while cost_met < card.cost:
		for mana in player_mana:
			if cost_met < card.cost and mana.color == References.ManaColor.Neutral:
				cost_met += 1
				mana_to_pay.append(mana.color)
		if cost_met < card.cost:
			card.get_parent().remove_child(card)
			hand.add_child(card)
			caster = null
			return
	# Continue if the player has enough mana to play the card
	for color in mana_to_pay:
		remove_mana(color)
	if card.target == References.TargetType.None:
		if card is AddEffectSelf:
			for duck in ducks:
				if duck.mana_color == card.color:
					caster = duck ## TEMPORARY TODO: in future, this has to be matched to the exact duck, not just the color
			card.do_effect(caster)
			caster = null
		else:
			card.do_effect()
		discard(card)
	else:
		current_card = card
		card.visible = false
		state = states.PlayerCardTarget

## Discard Card
func discard(card):
	card.get_parent().remove_child(card)
	discard_icon.add_child(card)
	card.visible = false
	discard_pile.append(card)

## Refill Deck
func refill():
	while not discard_pile.is_empty():
		var card = discard_pile.pop_front()
		card.get_parent().remove_child(card)
		deck_node.add_child(card)
		card.visible = false
		player_deck.append(card)
	player_deck.shuffle()

## Add Mana
func add_mana(mana_pip, amount):
	for i in range(amount):
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

## Empty Mana
func empty_mana():
	for i in range(len(player_mana)):
		player_mana.pop_front()
	mana_box.update_display(player_mana)

## Stat Change All
func stat_change_all(target_type, stat, amount):
	if target_type == References.TargetType.Duck:
		for duck in ducks:
			duck.change_stat(stat, amount)
	if target_type == References.TargetType.Enemy:
		for enemy in enemies:
			enemy.change_stat(stat, amount)

## Damage All
func damage_all(damage, reducible):
	for enemy in enemies:
		enemy.damage(damage, reducible)

## Damage All Ducks
func damage_all_ducks(damage, reducible):
	for duck in ducks:
		duck.damage(damage, reducible)

## Enemy Attack
func enemy_attack():
	if state == states.EnemyCards:
		state = states.EnemyBlock
	elif state == states.MinionAction:
		state = states.MinionBlock

## On Duck Attack
func _on_duck_attack(duck):
	if state == states.PlayerAction:
		attacker = duck
		for d in ducks:
			d.end_action_phase()
		action_phase_started = false
		state = states.PlayerAttackTarget

## On Duck Defend
func _on_duck_defend(duck):
	current_enemy_target = duck
	for d in ducks:
		d.end_block_phase()
	block_phase_started = false
	end_block_button.visible = false
	current_enemy.attack_target(current_enemy_target)
	if enemy_cards_played == enemy_cards_to_play:
		enemy_cards_played = 0
		state = states.MinionAction
	else:
		state = states.EnemyCards

## On Enemy Targeted
func _on_enemy_targeted(enemy):
	if state == states.PlayerAttackTarget:
		attacker.attack_target(enemy)
		attacker = null
		target_phase_started = false
		state = states.PlayerAction
	elif state == states.PlayerCardTarget:
		current_card.do_effect(enemy)
		discard(current_card)
		current_card = null
		target_phase_started = false
		state = states.PlayerAction
	for e in enemies:
		e.end_target_phase()

## On Duck Targeted
func _on_duck_targeted(duck):
	if state == states.PlayerCardTarget:
		current_card.do_effect(duck)
		discard(current_card)
		current_card = null
		target_phase_started = false
		state = states.PlayerAction
	for d in ducks:
		d.end_target_phase()

## On End Turn
func _on_end_turn():
	state = states.EndPlayer

## On End Block
func _on_end_block():
	for duck in ducks:
		duck.end_block_phase()
	block_phase_started = false
	end_block_button.visible = false
	current_enemy.attack_target(current_enemy_target)
	if enemy_cards_played == enemy_cards_to_play:
		enemy_cards_played = 0
		state = states.MinionAction
	else:
		state = states.EnemyCards
