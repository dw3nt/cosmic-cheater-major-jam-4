extends Area2D

signal heart_pickup_collected

export(float) var tweenDuration = 1.5

var startPos = Vector2.ZERO
var tweenValues = [ Vector2(0, -2), Vector2(0, 2) ]

onready var tween = $Tween


func _ready():
	startPos = position
	startTween()
	
	
func startTween():
	tween.interpolate_property(self, "position", startPos + tweenValues[0], startPos + tweenValues[1], tweenDuration)
	tween.start()
	
	
func _on_HeartPickUp_body_entered(body):
	emit_signal("heart_pickup_collected", self)


func _on_Tween_tween_all_completed():
	tweenValues.invert()
	startTween()
