extends Node

export var current_level = 2

func _ready():
	$"/root/State".current_level = current_level
