extends Control

signal room_ready
signal room_change_requested

const FIRST_LEVEL = "res://rooms/Level1.tscn"

var saveFile

onready var parallaxSpace = $SpaceParallaxBackground
onready var animation = $AnimationPlayer
onready var playButton = $MarginContainer/VBoxContainer/ButtonsWrap/PlayButton


func _init():
	add_user_signal("music_change_requested")
	

func _ready():
	saveFile = FileDataManager.new("user://save_data.data")
	var hasPlayed = saveFile.readValue("hasPlayed")
	if hasPlayed:
		playButton.text = "Continue"
	
	emit_signal("room_ready")
	emit_signal("music_change_requested", "res://assets/sounds/menu_music.ogg")
	
	
func _physics_process(delta):
	parallaxSpace.scroll_offset += Vector2(-70, 0) * delta


func _on_PlayButton_pressed():
	saveFile.writeValue("hasPlayed", true)
	var levelPath = saveFile.readValue("levelPath")
	if !levelPath:
		levelPath = FIRST_LEVEL
	
	emit_signal("room_change_requested", { "scene": levelPath, "transition": "SwipToMiddle" })
	
	
func _on_ControlsButton_pressed():
	animation.play("controls_slide_in")
	
	
func _on_ControlsMenu_main_menu_pressed():
	animation.play_backwards("controls_slide_in")
	
	
func _on_SettingsButton_pressed():
	animation.play("settings_slide_in")
	

func _on_SettingsMenu_previous_menu_pressed():
	animation.play_backwards("settings_slide_in")
	
	
func _on_SettingsMenu_save_data_erased():
	playButton.text = "Play"

	
func _on_CreditsButton_pressed():
	animation.play("credits_slide_in")
	
	
func _on_CreditsMenu_main_menu_pressed():
	animation.play_backwards("credits_slide_in")


func _on_QuitButton_pressed():
	get_tree().quit()
