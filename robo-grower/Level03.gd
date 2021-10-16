extends Node

export var current_level = 3

func _ready():
	$"/root/State".current_level = current_level
