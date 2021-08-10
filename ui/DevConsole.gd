extends Control

onready var historyText = $MarginContainer/VBoxContainer/InputHistoryTextEdit
onready var inputText = $MarginContainer/VBoxContainer/InputLineEdit


func _ready():
	displayConsole()
	

func displayConsole():
	inputText.grab_focus()
	
	
func appendTextToHistory(newText):
	var updateText = ""
	if historyText.text:
		updateText += "\n"
		
	updateText += newText
	historyText.text += updateText
	
	historyText.scroll_vertical = historyText.get_line_count()
	
	inputText.text = ""


func _on_InputLineEdit_text_entered(new_text):
	appendTextToHistory(new_text)
