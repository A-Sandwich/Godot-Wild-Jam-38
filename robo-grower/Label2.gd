extends Label


func _ready():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("win", self, "_win")

func _win():
	print($"/root/State".current_level, $"/root/State".total_levels)
	if $"/root/State".current_level == $"/root/State".total_levels:
		visible = true
