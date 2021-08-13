extends Control

signal restart_pressed
signal main_menu_pressed

var isInSettings = false

onready var animation = $AnimationPlayer
	
	
func _input(event):
	if event.is_action_pressed("pause") && !isInSettings:
		togglePause()
		
		
func togglePause():
	var isPaused = get_tree().paused
	var playDir = 1
	if isPaused:
		playDir *= -1
	
	animation.play("slide_in", -1, playDir, isPaused)
	if isPaused:
		yield(animation, "animation_finished")
		
	get_tree().paused = !isPaused
	

func _on_ResumeButton_pressed():
	togglePause()
	
	
func _on_RestartButton_pressed():
	emit_signal("restart_pressed")


func _on_SettingsButton_pressed():
	animation.play("settings_slide_in")
	isInSettings = true


func _on_SettingsMenu_previous_menu_pressed():
	animation.play_backwards("settings_slide_in")
	isInSettings = false


func _on_MainMenuButton_pressed():
	emit_signal("main_menu_pressed")


func _on_QuitButton_pressed():
	get_tree().quit()
