extends Area2D

signal seed_get


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Seed_body_entered(body):
	emit_signal("seed_get")
	self.queue_free()
