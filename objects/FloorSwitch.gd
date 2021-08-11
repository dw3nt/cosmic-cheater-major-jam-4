extends Area2D

export(NodePath) var attachedDoorPath

var bodyCount = 0
var isPressed = false
var attachedDoor

onready var animation = $AnimationPlayer


func _ready():
	if attachedDoorPath:
		attachedDoor = get_node(attachedDoorPath)


func updatePressedState():
	if bodyCount > 0:
		animation.play("pressed")
		isPressed = true
		if attachedDoor:
			attachedDoor.openDoor()
	else:
		animation.play("unpressed")
		isPressed = false
		if attachedDoor:
			attachedDoor.closeDoor()


func _on_FloorSwitch_body_entered(body):
	bodyCount += 1
	updatePressedState()


func _on_FloorSwitch_body_exited(body):
	bodyCount -= 1
	updatePressedState()
