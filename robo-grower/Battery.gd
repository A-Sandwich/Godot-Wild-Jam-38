extends ProgressBar

signal no_charge
signal charged

export var is_charging = true
var rate_of_charge = 10
var charge = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_charging:
		charge = charge + (delta * rate_of_charge)
	else:
		charge = charge - (delta * rate_of_charge * 2)
	if charge <= 0 and value != 0:
		emit_signal("no_charge")
	if charge > 0 and value == 0:
		emit_signal("charged")
	charge = clamp(charge, 0, 100)
	value = charge
