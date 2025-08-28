extends Control

## Components
@export var TNK_pip: ManaPip
@export var DPS_pip: ManaPip
@export var SUP_pip: ManaPip
@export var neutral_pip: ManaPip
@export var TNK_label: Label
@export var DPS_label: Label
@export var SUP_label: Label
@export var neutral_label: Label

@onready var container = $VFlowContainer
@onready var pips_labels = [TNK_pip, TNK_label, DPS_pip, DPS_label, SUP_pip, SUP_label, neutral_pip, neutral_label]

## Update the mana display
func update_display(mana):
	var mana_dict = count_mana(mana)
	for i in range(0, 8, 2):
		var pip = pips_labels[i]
		var label = pips_labels[i + 1]
		label.text = str(mana_dict[pip])
		# Hide and rearrange empty mana
		if mana_dict[pip] == 0:
			pip.visible = false
			container.move_child(pip, 3)
		else:
			pip.visible = true

## Count mana pips and organize them into a dictionary
func count_mana(mana):
	var mana_dict = {TNK_pip: 0, DPS_pip: 0, SUP_pip: 0, neutral_pip: 0}
	for pip in mana:
		match pip.color:
			References.ManaColor.Red:
				mana_dict[DPS_pip] += 1
			References.ManaColor.Blue:
				mana_dict[TNK_pip] += 1
			References.ManaColor.Purple:
				mana_dict[SUP_pip] += 1
			References.ManaColor.Neutral:
				mana_dict[neutral_pip] += 1
	return mana_dict
