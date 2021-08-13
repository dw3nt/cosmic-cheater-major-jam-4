extends Control

signal room_ready
signal room_change_requested

const FIRST_LEVEL = "res://rooms/Level1.tscn"

var saveFile

onready var animation = $AnimationPlayer
onready var playButton = $MarginContainer/VBoxContainer/ButtonsWrap/PlayButton


func _ready():
	saveFile = FileDataManager.new("user://save_data.data")
	var hasPlayed = saveFile.readValue("hasPlayed")
	if hasPlayed:
		playButton.text = "Continue"
	
	emit_signal("room_ready")


func _on_PlayButton_pressed():
	saveFile.writeValue("hasPlayed", true)
	var levelPath = saveFile.readValue("levelPath")
	if !levelPath:
		levelPath = FIRST_LEVEL
	
	emit_signal("room_change_requested", { "scene": levelPath, "transition": "SwipToMiddle" })
	
	
func _on_SettingsButton_pressed():
	animation.play("settings_slide_in")
	

func _on_SettingsMenu_main_menu_pressed():
	animation.play_backwards("settings_slide_in")


func _on_QuitButton_pressed():
	get_tree().quit()
