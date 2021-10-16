extends Area2D

signal discharge
signal charging

func _on_Shadow_body_entered(body):
	emit_signal("discharge")


func _on_Shadow_body_exited(body):
	emit_signal("charging")
