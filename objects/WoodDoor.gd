extends StaticBody2D

export(int) var doorCost = 0
export(bool) var isOpen = false setget setIsOpen, getIsOpen

onready var costLabel = $CostLabel
onready var animation = $AnimationPlayer
onready var topCollider = $TopCollider
onready var bottomCollider = $BottomCollider


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
		else:
			animation.play_backwards("slide_open")
			
	isOpen = val
	
	
func getIsOpen():
	return isOpen
