extends Control

signal main_menu_pressed

onready var animation = $AnimationPlayer
onready var cameraShakeCheckbox = $MarginContainer/VBoxContainer/OptionsWrap/CameraShakeOptionWrap/CameraShakeCheckBox
onready var devConsoleCheckbox = $MarginContainer/VBoxContainer/OptionsWrap/DevConsoleOptionWrap/DevConsoleCheckBox

var settingsFile


func _ready():
	settingsFile = FileDataManager.new("user://settings_data.data")
	
	var cameraShakeOption = settingsFile.readValue("camera_shake")
	if cameraShakeOption != null:
		cameraShakeCheckbox.pressed = cameraShakeOption
		
	var devConsoleOption = settingsFile.readValue("dev_console")
	if devConsoleOption != null:
		devConsoleCheckbox.pressed = devConsoleOption


func _on_MainMenuButton_pressed():
	emit_signal("main_menu_pressed")


func _on_ClearSaveButton_pressed():
	animation.play("slide_in_confirmation")
	

func _on_CancelButton_pressed():
	animation.play_backwards("slide_in_confirmation")


func _on_ConfirmButton_pressed():
	animation.play_backwards("slide_in_confirmation")
	var saveFile = FileDataManager.new("user://save_data.data")
	saveFile.eraseFile()


func _on_CameraShakeCheckBox_toggled(button_pressed):
	settingsFile.writeValue("camera_shake", button_pressed)


func _on_DevConsoleCheckBox_toggled(button_pressed):
	settingsFile.writeValue("dev_console", button_pressed)
