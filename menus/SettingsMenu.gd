extends Control

signal main_menu_pressed

onready var animation = $AnimationPlayer

var settingsFile


func _ready():
	settingsFile = FileDataManager.new("user://settings_data.data")


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
