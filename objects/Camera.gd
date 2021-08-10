extends Camera2D

var shakeDuration = 30.0
var shakeMagnitude = 0.0
var shakeRemain = 0.0


func _process(delta):
	shakeRemain = max(0, shakeRemain - ( (1 / shakeDuration) * shakeMagnitude ) )
	offset = Vector2( rand_range(-shakeRemain, shakeRemain), rand_range(-shakeRemain, shakeRemain) )
	

func shakeCamera(magnitude, duration):
	if shakeRemain < magnitude || shakeRemain <= 0:
		shakeDuration = duration
		shakeMagnitude = magnitude
		shakeRemain = shakeMagnitude
