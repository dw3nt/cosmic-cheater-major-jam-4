extends KinematicBody2D

var moveSpeed = 300
var moveDir = Vector2.RIGHT


func _physics_process(delta):
	move_and_slide(moveDir * moveSpeed)


func _on_Lifetime_timeout():
	queue_free()
