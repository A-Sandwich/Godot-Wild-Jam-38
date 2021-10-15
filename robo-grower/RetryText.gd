extends Label



func _on_Battery_charged():
	$RetryTextDisplay.stop()
	visible = false


func _on_Battery_no_charge():
	$RetryTextDisplay.start()


func _on_RetryTextDisplay_timeout():
	visible = true
