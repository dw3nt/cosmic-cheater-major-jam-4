extends Node2D

export(NodePath) var holderNodePath
export(Vector2) var holdOffset = Vector2(0, -7)

var holder
var mousePos
var holderLastPos

onready var sprite = $Sprite


func _ready():
	holder = get_node(holderNodePath)
	holderLastPos = holder.position


func _process(delta):
	mousePos = get_global_mouse_position()
	look_at(mousePos)
	sprite.flip_v = mousePos.x < position.x
	
	position = holderLastPos + holdOffset


func _on_PositionUpdateTimer_timeout():
	holderLastPos = holder.position
