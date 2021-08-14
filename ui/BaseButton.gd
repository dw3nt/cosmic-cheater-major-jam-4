extends Button

onready var clickAudio = $ClickAudio


func _on_PlayButton_mouse_entered():
	clickAudio.pitch_scale = 1.0
	clickAudio.volume_db = -20
	clickAudio.play()


func _on_PlayButton_pressed():
	clickAudio.pitch_scale = 0.5
	clickAudio.volume_db = -15
	clickAudio.play()
