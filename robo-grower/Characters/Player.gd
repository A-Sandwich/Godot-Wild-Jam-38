extends KinematicBody2D

signal start_charging
signal stop_charging

var speed = 500
var gravity = 32
var jumpforce = -1000
var velocity = Vector2.ZERO
var has_charge = true
var is_panning_to_goal = true
var goal_global_position

func _ready():
	$HUD/Battery.connect("no_charge", self, "_no_charge")
	$HUD/Battery.connect("charged", self, "_charged")
	var seeds = get_tree().get_nodes_in_group("seed")
	var position
	for plant_seed in seeds:
		# the last seed in group is the final goal? maybe.
		plant_seed.connect("seed_get", self, "_seed_get")
		goal_global_position = plant_seed.global_position
	var shadows = get_tree().get_nodes_in_group("Shadow")
	for shadow in shadows:
		print("connecting")
		shadow.connect("charging", self, "_on_charging")
		shadow.connect("discharge", self, "_on_discharge")
	


func get_input():
	if not has_charge or is_panning_to_goal:
		return
	# Detect up/down/left/right keystate and only move when pressed.
	if Input.is_action_pressed('ui_right'):
		walk(speed, true)
	elif Input.is_action_pressed('ui_left'):
		walk(-speed, true)
	else:
		walk(lerp(velocity.x, 0, 0.25), false)

	if Input.is_action_pressed('jump') and is_on_floor():
		jump()

func jump():
	velocity.y = jumpforce
	if not $Jump.playing:
		$Jump.play()

func walk(speed, play_sound):
	velocity.x = speed
	if play_sound:
		if not $Walk.playing:
			$Walk.play()
	elif $Walk.playing:
		$Walk.stop()


func _physics_process(delta):
	get_input()
	animate(delta)
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity(delta):
	velocity.y += gravity + delta

func animate(delta):
	if $AnimatedSprite.is_playing() and velocity == Vector2():
		$AnimatedSprite.stop()
	elif not $AnimatedSprite.is_playing():
		$AnimatedSprite.play()
	if is_panning_to_goal:
		pan_to_goal(delta)

func pan_to_goal(delta):
	var current_position = Vector2($Camera2D.global_position.x + 1000 * delta, $Camera2D.global_position.y + 1000 * delta)
	current_position.x = clamp(current_position.x, -1000000000, goal_global_position.x)
	current_position.y = clamp(current_position.y, -1000000000, goal_global_position.y)
	$Camera2D.global_position = current_position
	if current_position == goal_global_position:
		is_panning_to_goal = false
		$PanTimer.start()

func _on_charging():
	print("Charge")
	emit_signal("start_charging")

func _on_discharge():
	print("Discharge")
	emit_signal("stop_charging")

func _no_charge():
	velocity = Vector2.ZERO
	$AnimatedSprite.stop()
	$Light2D.energy = 0
	has_charge = false

func _charged():
	has_charge = true
	$Light2D.energy = 1

func _seed_get():
	print("Seed gort")

func _on_PanTimer_timeout():
	$Camera2D.position = Vector2.ZERO
	_on_charging()
	$PanTimer.stop()
