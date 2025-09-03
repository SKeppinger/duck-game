extends TextureRect
class_name HealthBar

## Child References
@onready var fill = $Fill

## Variables
var max = 0
var current = 0

## Setup
func setup(enter_max):
	max = enter_max
	current = max

## Update
func update(new_current):
	current = new_current

## Process
func _process(_delta):
	if max > 0:
		var scale_vector = Vector2(0.5, 1)
		fill.get_rect().size = scale_vector
