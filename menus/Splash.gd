extends Control

signal room_ready
signal room_change_requested

export(String, FILE, "*.tscn") var nextScene
export(String) var transition = ""


func _ready():
	emit_signal('room_ready')
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("room_change_requested", {"scene": nextScene, "transition": transition})
