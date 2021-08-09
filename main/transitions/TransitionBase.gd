extends Control

var entranceAnimationName
var exitAnimationName

onready var animation = $AnimationPlayer


func playEntrance():
	animation.play(entranceAnimationName)
	

func playExit():
	animation.play(exitAnimationName)
