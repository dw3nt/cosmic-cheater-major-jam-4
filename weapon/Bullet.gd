extends KinematicBody2D

export(float) var aimOffset = 0

onready var collider = $HitDetect/CollisionShape2D
onready var collisionAudio = $CollisionAudio

var moveSpeed = 300
var moveDir = Vector2.RIGHT
var damage = 1


func _ready():
	moveDir = moveDir.rotated(deg2rad(rand_range(-aimOffset, aimOffset)))


func _physics_process(delta):
	move_and_slide(moveDir * moveSpeed)


func _on_Lifetime_timeout():
	queue_free()


func _on_HitDetect_body_entered(body):
	collisionAudio.play()
	visible = false
	set_physics_process(false)
	
	yield(collisionAudio, "finished")
	queue_free()
