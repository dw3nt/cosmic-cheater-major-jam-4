extends StaticBody2D

onready var animation = $AnimationPlayer


func openDoor():
	animation.play("slide_up")
	
	
func closeDoor():
	animation.play_backwards("slide_up")
