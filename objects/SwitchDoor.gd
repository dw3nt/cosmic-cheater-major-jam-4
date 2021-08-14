extends StaticBody2D

onready var animation = $AnimationPlayer
onready var collider = $CollisionShape2D
onready var doorOpenAudio = $DoorOpenAudio
onready var doorCloseAudio = $DoorCloseAudio


func _ready():
	var newColliderShape = collider.shape.duplicate()
	collider.shape = newColliderShape


func openDoor():
	animation.play("slide_up")
	doorOpenAudio.play()
	
	
func closeDoor():
	animation.play_backwards("slide_up")
	doorCloseAudio.play()
