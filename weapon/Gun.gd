extends Node2D

signal bullet_fired

export(NodePath) var holderNodePath
export(Vector2) var holdOffset = Vector2(0, -7)
export(float) var shootCooldown = 0.5
export(int) var maxRecoil = 4

var holder
var mousePos
var holderLastPos
var canShoot = true
var recoil = 0

onready var sprite = $Sprite
onready var shootCooldownTimer = $ShootCooldownTimer
onready var bulletSpawnPos = $BulletSpawnPosition


func _ready():
	holder = get_node(holderNodePath)
	holderLastPos = holder.position


func _process(delta):
	if holder == null:
		set_process(false)
		queue_free()
		return
	
	mousePos = get_global_mouse_position()
	look_at(mousePos)
	sprite.flip_v = mousePos.x < position.x
	sprite.offset.x = -recoil
	
	position = holderLastPos + holdOffset
	
	recoil = max(0, recoil - 1)
	if Input.is_action_pressed("shoot") && canShoot:
		emit_signal("bullet_fired")
		
		recoil = maxRecoil
		canShoot = false
		shootCooldownTimer.start(shootCooldown)


func _on_PositionUpdateTimer_timeout():
	if holder != null:
		holderLastPos = holder.position


func _on_ShootCooldownTimer_timeout():
	canShoot = true
