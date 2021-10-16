extends ProgressBar

signal no_charge
signal charged

var rate_of_charge = 10
var charge = 0
var number_of_shadows = 0

func _ready():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("start_charging", self, "_start_charging")
	player.connect("stop_charging", self, "_stop_charging")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if number_of_shadows == 0:
		charge = charge + (delta * rate_of_charge)
	else:
		charge = charge - (delta * rate_of_charge * 2)
	if charge <= 0 and value != 0:
		emit_signal("no_charge")
		get_tree().paused = true
	if charge > 0 and value == 0:
		emit_signal("charged")
		get_tree().paused = false
	charge = clamp(charge, 0, 100)
	value = charge


func _start_charging():
	number_of_shadows = clamp((number_of_shadows - 1), 0, 99999)

func _stop_charging():
	number_of_shadows = clamp((number_of_shadows + 1), 0, 99999)
