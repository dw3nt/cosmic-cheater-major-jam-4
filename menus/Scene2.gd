extends Control

signal room_ready
signal room_change_requested

export(String, FILE, "*.tscn") var nextScene
export(String) var transition = ""


func _init():
	add_user_signal("music_change_requested")


func _ready():	
	emit_signal("room_ready")
	
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("room_change_requested", {"scene": nextScene, "transition": transition})
