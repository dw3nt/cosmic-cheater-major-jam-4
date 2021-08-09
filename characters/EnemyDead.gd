extends KinematicBody2D

var moveDir = 1
var gravity = 8
var velocity = Vector2.ZERO
var knockbackSpeed = 40
var knockupSpeed = 130

onready var sprite = $Sprite
onready var groundRay = $GroundRay


func _ready():
	velocity.x = knockbackSpeed * moveDir
	velocity.y = -knockupSpeed
	
	sprite.flip_h = moveDir > 0
	

func _physics_process(delta):
	velocity.y += gravity
	velocity = move_and_slide(velocity)
	
	if is_on_floor() || groundRay.is_colliding():
		velocity = Vector2.ZERO


func _on_GroundRayDelayTimer_timeout():
	groundRay.enabled = true
