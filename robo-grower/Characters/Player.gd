extends KinematicBody2D

var speed = 500
var gravity = 32
var jumpforce = -1000
var velocity = Vector2.ZERO
var has_charge = true

func _ready():
	$HUD/Battery.connect("no_charge", self, "_no_charge")
	$HUD/Battery.connect("charged", self, "_charged")

func get_input():
	if not has_charge:
		return
	# Detect up/down/left/right keystate and only move when pressed.
	if Input.is_action_pressed('ui_right'):
		velocity.x = speed
	elif Input.is_action_pressed('ui_left'):
		velocity.x = -speed
	else:
		velocity.x = lerp(velocity.x, 0, 0.25)

	if Input.is_action_pressed('jump') and is_on_floor():
		velocity.y = jumpforce


func _physics_process(delta):
	get_input()
	animate()
	apply_gravity(delta)
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity(delta):
	velocity.y += gravity + delta

func animate():
	if $AnimatedSprite.is_playing() and velocity == Vector2():
		$AnimatedSprite.stop()
	elif not $AnimatedSprite.is_playing():
		$AnimatedSprite.play()


func _on_Shadow_charge():
	$HUD/Battery.is_charging = true


func _on_Shadow_discharge():
	$HUD/Battery.is_charging = false

func _no_charge():
	velocity = Vector2.ZERO
	$AnimatedSprite.stop()
	$Light2D.energy = 0
	has_charge = false

func _charged():
	has_charge = true
	$Light2D.energy = 1
