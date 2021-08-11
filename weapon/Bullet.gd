extends KinematicBody2D

export(float) var aimOffset = 0

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
	queue_free()
