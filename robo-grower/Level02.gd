extends Node

export var current_level = 2

func _ready():
	get_node("/root/State").current_level = current_level
