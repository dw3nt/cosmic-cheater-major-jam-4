extends Control

signal room_ready
signal room_change_requested

export(String, FILE, "*.tscn") var scene1
export(String) var transition = ""


func _ready():
	emit_signal('room_ready')
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("room_change_requested", {"scene": scene1, "transition": transition})
