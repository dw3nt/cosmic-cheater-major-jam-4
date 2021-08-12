extends Control

onready var heartWrap = $TopMarginWrap/HBoxContainer/HeartWrap
onready var coinLabel = $TopMarginWrap/HBoxContainer/CoinsWrap/CoinsLabel


func _ready():
	visible = true


func updateHearts(hp, maxHp):
	for index in range(heartWrap.get_child_count()):
		var currentHeart = heartWrap.get_child(index)
		if index <= hp - 1:
			currentHeart.fillHeart()
		else:
			currentHeart.emptyHeart()
			
			
func updateCoins(coins):
	coinLabel.text = str(coins)
