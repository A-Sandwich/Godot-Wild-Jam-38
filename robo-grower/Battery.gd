extends ProgressBar

signal no_charge
signal charged

export var is_charging = false
var rate_of_charge = 10
var charge = 0
var game_started = false

func _ready():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("start_charging", self, "_start_charging")
	player.connect("stop_charging", self, "_stop_charging")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game_started:
		return
	if is_charging:
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
	print("start")
	game_started = true
	is_charging = true

func _stop_charging():
	print("stop")
	is_charging = false
