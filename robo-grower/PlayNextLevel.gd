extends Button

func _ready():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("win", self, "_win")

func _on_PlayNextLevel_pressed():
	var current_level = $"/root/State".current_level
	get_tree().change_scene("res://Level0"+str(current_level + 1)+".tscn")

func _win():
	if $"/root/State".current_level + 1 > $"/root/State".total_levels:
		return
	visible = true
