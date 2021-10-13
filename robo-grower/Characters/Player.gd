extends KinematicBody2D

var speed = 250
var velocity = Vector2()

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	animate(velocity)

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)

func animate(velocity):
	if $AnimatedSprite.is_playing() and velocity == Vector2():
		$AnimatedSprite.stop()
	elif not $AnimatedSprite.is_playing():
		$AnimatedSprite.play()
	
