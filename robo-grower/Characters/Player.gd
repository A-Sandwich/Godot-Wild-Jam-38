extends KinematicBody2D

signal start_charging
signal stop_charging

var speed = 500
var gravity = 32
var jumpforce = -1000
var velocity = Vector2.ZERO
var has_charge = true
var is_panning_to_goal = true
var seeds
var seed_count = 0
var total_seeds = 0

func _ready():
	$HUD/Battery.connect("no_charge", self, "_no_charge")
	$HUD/Battery.connect("charged", self, "_charged")
	seeds = get_tree().get_nodes_in_group("seed")
	var position
	for plant_seed in seeds:
		total_seeds += 1
		# the last seed in group is the final goal? maybe.
		plant_seed.connect("seed_get", self, "_seed_get")
	sort_seeds_by_distance()
	var shadows = get_tree().get_nodes_in_group("Shadow")
	for shadow in shadows:
		print("connecting")
		shadow.connect("charging", self, "_on_charging")
		shadow.connect("discharge", self, "_on_discharge")

func sort_seeds_by_distance():
	var sorted_array = Array()
	for plant_seed in seeds:
		if sorted_array.size() == 0:
			sorted_array.append(plant_seed)
		else:
			var distance = global_position.distance_to(plant_seed.global_position)
			for sorted_seed in sorted_array:
				var sorted_distance = global_position.distance_to(sorted_seed.global_position)
				if sorted_distance > distance:
					sorted_array.push_front(plant_seed)
					break
			if not sorted_array.has(plant_seed):
				sorted_array.push_back(plant_seed)
	seeds = sorted_array

func new_level_or_retry():
	if $"/root/State".should_pan:
		$"/root/State".should_pan = false
	else:
		is_panning_to_goal = false

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

	if Input.is_action_pressed('jump'):
		jump()

func jump():
	if not is_on_floor():
		return
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
	if $WinAnimation.is_playing():
		apply_gravity(delta)
		jump()
		velocity.x = 0 # don't jump off a ledge
		velocity = move_and_slide(velocity, Vector2.UP)
		return
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
	if len(seeds) == 0:
		return
	var goal_global_position = seeds[0].global_position
	var distance_to_target = $Camera2D.global_position.distance_to(goal_global_position)
	var camera_velocity = (goal_global_position - $Camera2D.global_position).normalized() * 1000
	$Camera2D.global_position += camera_velocity * get_physics_process_delta_time()
	if $Camera2D.global_position == goal_global_position or distance_to_target < 300:
		seeds.erase(seeds[0])
		if len(seeds) == 0:
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
	seed_count += 1
	if seed_count == total_seeds:
		print("win!")
		$WinAnimation.play("Win")
	print("Seed gort")

func _on_PanTimer_timeout():
	$Camera2D.position = Vector2.ZERO
	_on_charging()
	$PanTimer.stop()
