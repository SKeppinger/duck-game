extends Node

## Duck Types
enum DuckType {DPS, TNK, SUP}

## Effect Types
enum EffectType {UpgradePermanent, UpgradeAbility, Debuff}

## Card Types
enum CardType {Event, Permanent}

## Card Traits
enum Trait {Spell, Weapon, Artifact, Armor, Ability, Tactic}

## Target Types
enum TargetType {None, Duck, Enemy}

## Mana Colors
enum ManaColor {Red, Blue, Purple, Neutral}

## Encounter States
enum EncounterState {StartPlayer, Draw, Generate, PlayerAction, PlayerAttackTarget, PlayerCardTarget, EndPlayer, 
	StartEnemy, EnemyCards, EnemyBlock, MinionAction, MinionBlock, EndEnemy}
