extends Button

onready var clickAudio = $ClickAudio


func _on_PlayButton_mouse_entered():
	clickAudio.pitch_scale = 1.0
	clickAudio.play()


func _on_PlayButton_pressed():
	clickAudio.pitch_scale = 0.5
	clickAudio.play()
