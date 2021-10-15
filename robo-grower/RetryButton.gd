extends TextureButton

func _on_RetryButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
