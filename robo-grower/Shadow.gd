extends Area2D

signal discharge
signal charge

func _on_Shadow_body_entered(body):
	emit_signal("discharge")


func _on_Shadow_body_exited(body):
	emit_signal("charge")
