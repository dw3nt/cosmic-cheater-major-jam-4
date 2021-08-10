extends Control

onready var heartWrap = $TopMarginWrap/HeartWrap


func updateHearts(hp, maxHp):
	for index in range(heartWrap.get_child_count()):
		var currentHeart = heartWrap.get_child(index)
		if index <= hp - 1:
			currentHeart.fillHeart()
		else:
			currentHeart.emptyHeart()
