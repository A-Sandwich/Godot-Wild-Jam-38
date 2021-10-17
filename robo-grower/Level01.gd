extends Node

export var current_level = 1

func _ready():
	$"/root/State".set_level(current_level)
