extends Node

var should_pan = true
var current_level = 0
var total_levels = 4

func set_should_pan(pan):
	should_pan = pan

func set_level(level):
	if current_level != level:
		current_level = level
		should_pan = true
	else:
		should_pan = false

