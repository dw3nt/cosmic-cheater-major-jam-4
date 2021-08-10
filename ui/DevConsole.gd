extends Control

var commandOutputMap = {
	# modifies specific properties on the player
	"player.jump=" : "Player jump modified!",		#eg: "player.jump=300"
	"player.gravity=": "Player gravity modified!",
	"player.fire_rate=": "Player fire rate modified!",
	"player.damage=": "Player damage modified!",
	
	# changes gravity variable for ALL enemies makes them fly into the air
	"enemies.gravity=": "Enemies gravity modified!",	# eg: "enemies.gravity=-200"
	
	# god mode
	"painkiller=": "God Mode activated!",		# eg: "painkiller" disables player hurtbox
	
	# add money per ! character (Sims reference)
	"rosebud!": "Money added!"			# eg: "rosebud!!!" gives 300 gold
}

onready var historyText = $MarginContainer/VBoxContainer/InputHistoryTextEdit
onready var inputText = $MarginContainer/VBoxContainer/InputLineEdit


func _ready():
	displayConsole()
	

func displayConsole():
	inputText.grab_focus()
	
	
func appendTextToHistory(newText):
	newText = cleanInput(newText)
	var command = checkForCommand(newText)
	
	var updateText = ""
	if historyText.text:
		updateText += "\n"
		
	updateText += newText + "\n\t"
	
	if command:
		updateText += commandOutputMap[command]
	else:
		updateText += "Error! Invalid command!"
	
	historyText.text += updateText
	historyText.scroll_vertical = historyText.get_line_count()
	inputText.text = ""
	
	
func cleanInput(newText):
	return newText.strip_edges().replace(" ", "").to_lower()
	
	
func checkForCommand(inputText):
	for command in commandOutputMap.keys():
		
		if command in inputText:
			return command
			
	return false


func _on_InputLineEdit_text_entered(new_text):
	appendTextToHistory(new_text)
