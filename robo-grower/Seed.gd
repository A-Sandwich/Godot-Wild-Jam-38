extends Area2D

signal seed_get

func _on_Seed_body_entered(body):
	if not visible:
		return
	emit_signal("seed_get")
	$obtain.play()
	visible = false


func _on_obtain_finished():
	self.queue_free()
