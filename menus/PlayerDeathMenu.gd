extends Control

signal player_death_menu_main_menu_pressed
signal restart_pressed

onready var animation = $AnimationPlayer


func _ready():
	visible = true


func enter():
	animation.play("fade_in")
	
	
func _on_RestartButton_pressed():
	emit_signal("restart_pressed")


func _on_MainMenuButton_pressed():
	emit_signal("player_death_menu_main_menu_pressed")


func _on_QuitButton_pressed():
	get_tree().quit()
