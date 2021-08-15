extends Control

signal previous_menu_pressed
signal save_data_erased

export(bool) var showClearSaveButton = true
export(String) var previousButtonText = "Main Menu"

onready var previousMenuButton = $MarginContainer/VBoxContainer/PreviousMenuButton
onready var clearSaveButton = $MarginContainer/VBoxContainer/OptionsWrap/ClearSaveButton
onready var animation = $AnimationPlayer
onready var cameraShakeCheckbox = $MarginContainer/VBoxContainer/OptionsWrap/CameraShakeOptionWrap/CameraShakeCheckBox
onready var devConsoleCheckbox = $MarginContainer/VBoxContainer/OptionsWrap/DevConsoleOptionWrap/DevConsoleCheckBox
onready var clickAudio = $ClickAudio

var settingsFile
var isReady = false


func _ready():
	settingsFile = FileDataManager.new("user://settings_data.data")
	
	var cameraShakeOption = settingsFile.readValue("camera_shake")
	if cameraShakeOption != null:
		cameraShakeCheckbox.pressed = cameraShakeOption
		
	var devConsoleOption = settingsFile.readValue("dev_console")
	if devConsoleOption != null:
		devConsoleCheckbox.pressed = devConsoleOption
		
	previousMenuButton.text = previousButtonText
	
	if showClearSaveButton:
		clearSaveButton.disabled = false
		clearSaveButton.modulate.a = 1
		clearSaveButton.mouse_filter = MOUSE_FILTER_STOP
	else:
		clearSaveButton.disabled = true
		clearSaveButton.modulate.a = 0
		clearSaveButton.mouse_filter = MOUSE_FILTER_IGNORE
		
	isReady = true


func _on_PreviousMenuButton_pressed():
	emit_signal("previous_menu_pressed")
	
	var sl = SettingsLoader.new()
	sl.loadSettingsData()


func _on_ClearSaveButton_pressed():
	animation.play("slide_in_confirmation")
	

func _on_CancelButton_pressed():
	animation.play_backwards("slide_in_confirmation")


func _on_ConfirmButton_pressed():
	animation.play_backwards("slide_in_confirmation")
	var saveFile = FileDataManager.new("user://save_data.data")
	saveFile.eraseFile()
	GameManager.resetSaveData()
	emit_signal("save_data_erased")


func _on_CameraShakeCheckBox_toggled(button_pressed):
	settingsFile.writeValue("camera_shake", button_pressed)
	if isReady:
		clickAudio.pitch_scale = 0.5
		clickAudio.play()


func _on_DevConsoleCheckBox_toggled(button_pressed):
	settingsFile.writeValue("dev_console", button_pressed)
	if isReady:
		clickAudio.pitch_scale = 0.5
		clickAudio.play()


func _on_CameraShakeCheckBox_mouse_entered():
	clickAudio.pitch_scale = 1.0
	clickAudio.play()


func _on_DevConsoleCheckBox_mouse_entered():
	clickAudio.pitch_scale = 1.0
	clickAudio.play()
