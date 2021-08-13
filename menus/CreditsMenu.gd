extends Control

signal main_menu_pressed


func _on_MainMenuButton_pressed():
	emit_signal("main_menu_pressed")
