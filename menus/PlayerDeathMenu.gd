extends Control

signal restart_pressed

onready var animation = $AnimationPlayer


func enter():
	animation.play("fade_in")


func _on_RestartLevelButton_pressed():
	emit_signal("restart_pressed")
	
	
func _on_MainMenuButton_pressed():
	pass # transition to main menu scene


func _on_QuitGameButton_pressed():
	get_tree().quit()
