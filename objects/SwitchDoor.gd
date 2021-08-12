extends StaticBody2D

onready var animation = $AnimationPlayer
onready var collider = $CollisionShape2D


func _ready():
	var newColliderShape = collider.shape.duplicate()
	collider.shape = newColliderShape


func openDoor():
	animation.play("slide_up")
	
	
func closeDoor():
	animation.play_backwards("slide_up")
