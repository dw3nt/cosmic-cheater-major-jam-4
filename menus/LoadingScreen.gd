extends Control

signal room_ready
signal room_change_requested

const FIRST_LEVEL = "res://rooms/Level1.tscn"

var tweenValues = [Color(1, 1, 1, 1), Color(1, 1, 1, 0)]
var saveFile

onready var loadingLabel = $CenterContainer/LoadingLabel
onready var tween = $Tween


func _ready():
	saveFile = FileDataManager.new("user://save_data.data")
	startTween()
	
	yield(get_tree().create_timer(0.15), "timeout")
	emit_signal("room_ready")


func startTween():
	tween.interpolate_property(loadingLabel, "self_modulate", tweenValues[0], tweenValues[1], 1.25)
	tween.start()


func _on_Tween_tween_all_completed():
	tweenValues.invert()
	startTween()


func _on_Timer_timeout():
	saveFile.writeValue("hasPlayed", true)
	var levelPath = saveFile.readValue("levelPath")
	if !levelPath:
		levelPath = FIRST_LEVEL
	
	emit_signal("room_change_requested", { "scene": levelPath, "transition": "FadeInOut" })
