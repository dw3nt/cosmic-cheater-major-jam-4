extends KinematicBody2D

export(float) var gravity = 8

var velocity = Vector2.ZERO
var pushSpeed = 15
var pushDir = 0

onready var pushAudio = $PushAudio


func _physics_process(delta):
	velocity.x = pushSpeed * pushDir
	
	if !is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = gravity
		
	if velocity.x != 0:
		if !pushAudio.playing:
			pushAudio.play()
	
	move_and_slide(velocity, Vector2.UP)


func _on_PushDetect_body_entered(body):
	pushDir = sign(position.x - body.position.x)


func _on_PushDetect_body_exited(body):
	pushDir = 0
