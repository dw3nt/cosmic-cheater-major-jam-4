extends KinematicBody2D

export(float) var moveSpeed = 75
export(float) var jumpForce = 200
export(float) var gravity = 8

var velocity = Vector2.ZERO
var moveDir = 0

onready var groundRay = $GroundRay
onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var forwardRay = $ForwardRay

func _ready():
	moveDir = sign(rand_range(-1, 1))
	forwardRay.cast_to.x *= moveDir


func _physics_process(delta):
	if forwardRay.is_colliding():
		moveDir *= -1
		forwardRay.cast_to.x *= -1
	
	velocity.x = moveSpeed * moveDir
	
	if !is_on_floor() && !groundRay.is_colliding():
		velocity.y += gravity
	else:
		velocity.y = 0
	
	if velocity.x != 0:
		animation.play("run")
		
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	move_and_slide(velocity, Vector2.UP)
