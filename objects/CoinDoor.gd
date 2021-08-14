extends StaticBody2D

export(int) var doorCost = 0
export(bool) var isOpen = false setget setIsOpen, getIsOpen

onready var costLabel = $CostLabel
onready var animation = $AnimationPlayer
onready var topCollider = $TopCollider
onready var bottomCollider = $BottomCollider
onready var doorOpenAudio = $DoorOpenAudio
onready var doorCloseAudio = $DoorCloseAudio


func _ready():
	costLabel.text = str(doorCost)
	
	var newTopColliderShape = topCollider.shape.duplicate()
	topCollider.shape = newTopColliderShape
	
	var newBottomColliderShape = bottomCollider.shape.duplicate()
	bottomCollider.shape = newBottomColliderShape
	
	
func setIsOpen(val):
	if val != isOpen:
		if val:
			animation.play("slide_open")
			doorOpenAudio.play()
		else:
			animation.play_backwards("slide_open")
			doorCloseAudio.play()
			
	isOpen = val
	
	
func getIsOpen():
	return isOpen
