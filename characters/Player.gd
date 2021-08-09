extends KinematicBody2D

export(float) var moveSpeed = 150
export(float) var jumpForce = 200
export(float) var gravity = 8

var velocity = Vector2.ZERO

onready var groundRay = $GroundRay
onready var animation = $AnimationPlayer
onready var sprite = $Sprite


func _physics_process(delta):
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x *= moveSpeed
	
	if !is_on_floor() && !groundRay.is_colliding():
		velocity.y += gravity
	else:
		if Input.is_action_just_pressed("move_up"):
			velocity.y = -jumpForce
		else:
			velocity.y = 0
			
	if velocity.y < 0:
		animation.play("jump_up")
	elif velocity.y > 0: 
		animation.play("jump_down")
	elif velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")
		
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	move_and_slide(velocity, Vector2.UP)
