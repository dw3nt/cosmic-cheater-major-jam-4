extends Sprite

export(float) var tweenDuration = 5

var startPos = Vector2.ZERO
var tweenValues = [ Vector2(0, -16), Vector2(0, 16) ]
var cratePath = null

onready var tween = $Tween


func _ready():
	startPos = position
	startTween()
	
	
func startTween():
	tween.interpolate_property(self, "position", startPos + tweenValues[0], startPos + tweenValues[1], tweenDuration)
	tween.start()


func _on_Tween_tween_all_completed():
	tweenValues.invert()
	startTween()
