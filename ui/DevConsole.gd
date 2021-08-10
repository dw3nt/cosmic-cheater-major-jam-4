extends Control

signal command_inputted

var cm = load("res://scripts/CommandManager.gd").new()
var canToggle = true

onready var historyText = $MarginContainer/VBoxContainer/InputHistoryTextEdit
onready var inputText = $MarginContainer/VBoxContainer/InputLineEdit
onready var animation = $AnimationPlayer


func _input(event):
	if event.is_action_pressed("console"):
		get_tree().paused = !get_tree().paused
		toggleConsole()
	
	
func toggleConsole():
	if !canToggle:
		return
		
	if visible:
		hideConsole()
	else:
		displayConsole()
	

func displayConsole():
	animation.play("slide_in")
	
	
func hideConsole():
	animation.play("slide_out")
	
	
func appendTextToHistory(newText):
	var parsedText = cleanInput(newText)
	var command = checkForCommand(parsedText)
	
	var updateText = ""
	if historyText.text:
		updateText += "\n"
		
	updateText += newText + "\n\t"
	
	if command:
		var commandValue = cm.parseCommandValue(command, parsedText)
		if commandValue == null:
			updateText += "Error! Invalid argument!"
		else:
			updateText += cm.commandOutputMap[command]
			emit_signal("command_inputted", command, commandValue)
	else:
		updateText += "Error! Invalid command!"
	
	historyText.text += updateText
	historyText.scroll_vertical = historyText.get_line_count()
	inputText.text = ""
	
	
func cleanInput(newText):
	return newText.strip_edges().replace(" ", "").to_lower()
	
	
func checkForCommand(text):
	for commandName in cm.commands.keys():
		if cm.commands[commandName] in text:
			return commandName
			
	return false
	
	
func _on_InputLineEdit_text_changed(new_text):
	inputText.text = new_text.replace("`", "")
	inputText.caret_position = inputText.text.length()


func _on_InputLineEdit_text_entered(new_text):
	appendTextToHistory(new_text)


func _on_AnimationPlayer_animation_started(anim_name):
	canToggle = false


func _on_AnimationPlayer_animation_finished(anim_name):
	canToggle = true
	if visible:
		inputText.grab_focus()
	else:
		inputText.release_focus()
