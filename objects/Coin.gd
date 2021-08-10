extends Area2D

signal coin_collected

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


func _on_Coin_body_entered(body):
	emit_signal("coin_collected")
	queue_free()


func _on_Tween_tween_all_completed():
	tweenValues.invert()
	startTween()
