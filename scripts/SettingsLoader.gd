extends Node
class_name SettingsLoader

var settingsFile = FileDataManager.new("user://settings_data.data")


func loadSettingsData():
	var cameraShake = settingsFile.readValue("camera_shake")
	if cameraShake != null:
		GameManager.cameraShakeEnabled = cameraShake
		
	var devConsole = settingsFile.readValue("dev_console")
	if devConsole != null:
		GameManager.devConsoleEnabled = devConsole
