extends Control

signal room_ready
signal room_change_requested

func _init():
	add_user_signal("music_change_requested")
	

func _ready():
	yield(get_tree().create_timer(0.2), "timeout")
	emit_signal("room_change_requested", { "scene": "res://menus/MainMenu.tscn" })
