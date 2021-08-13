extends Camera2D

var shakeMagnitude = 0.0
var shakeRemain = 0.0

onready var shakeTimer = $ShakeTimer


func _process(delta):
	shakeRemain = max(0, shakeRemain - ( ( (shakeTimer.wait_time - shakeTimer.time_left) / shakeTimer.wait_time) * shakeMagnitude ) )
	offset = Vector2( rand_range(-shakeRemain, shakeRemain), rand_range(-shakeRemain, shakeRemain) )
	

func shakeCamera(magnitude, duration):
	if (shakeRemain < magnitude || shakeRemain <= 0) && GameManager.cameraShakeEnabled:
		shakeTimer.start(duration)
		shakeMagnitude = magnitude
		shakeRemain = shakeMagnitude


func _on_ShakeTimer_timeout():
	shakeRemain = 0
