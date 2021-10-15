extends Area2D

signal discharge
signal charging

func _on_Shadow_body_entered(body):
	print("entered")
	emit_signal("discharge")


func _on_Shadow_body_exited(body):
	print("Exit")
	emit_signal("charging")
