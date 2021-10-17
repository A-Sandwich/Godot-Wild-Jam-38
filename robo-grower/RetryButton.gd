extends TextureButton

func _ready():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("retry", self, "_on_RetryButton_pressed")

func _on_RetryButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
