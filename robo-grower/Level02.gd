extends Node

export var current_level = 2

func _ready():
	$"/root/State".set_level(current_level)
