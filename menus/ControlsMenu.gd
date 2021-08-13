extends Control

signal main_menu_pressed


func _on_Main_Menu_pressed():
	emit_signal("main_menu_pressed")
