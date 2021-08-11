extends Node2D

signal room_ready
signal room_change_requested

const CMD_EXE_SCRIPT = preload("res://scripts/CommandExecutioner.gd")

const BULLET_SCENE = preload("res://weapon/Bullet.tscn")
const COIN_SCENE = preload("res://objects/Coin.tscn")

var cmdMgr = load("res://scripts/CommandManager.gd").new()
var cmdExe

var bulletDamage = 1
var coins = 0

onready var player = $Player
onready var camera = $Player/Camera
onready var gun = $Gun
onready var bulletWrap = $BulletWrap
onready var enemyWrap = $EnemyWrap
onready var crateWrap = $CrateWrap
onready var levelUi = $UIWrap/LevelUi
onready var devConsole = $UIWrap/DevConsole


func _ready():
	cmdExe = CMD_EXE_SCRIPT.new(self, player, gun, enemyWrap)
	
	get_tree().get_root().connect("size_changed", self, "_on_Root_size_changed")
	setCustomCursor()
	
	player.connect("player_damaged", self, "_on_Player_player_damaged")
	player.connect("player_died", self, "_on_Player_player_died")
	gun.connect("bullet_fired", self, "_on_Gun_bullet_fired")
	
	levelUi.updateHearts(player.hp, player.maxHp)
	levelUi.updateCoins(coins)
	
	for index in range(enemyWrap.get_child_count()):
		enemyWrap.get_child(index).connect("enemy_died", self, "_on_Enemy_enemy_died")
	
	for index in range(crateWrap.get_child_count()):
		crateWrap.get_child(index).connect("loot_spawned", self, "_on_Crate_loot_spawned")
		
	emit_signal("room_ready")
	
	
func setCustomCursor():
	var windowSize = OS.get_window_size()
	var viewportSize = get_viewport_rect().size
	
	var aimCursorPath = "res://assets/images/ui/aimer-1x.png"
	var hotspot = Vector2(8, 8)
	
	if windowSize.x / viewportSize.x >= 4:
		aimCursorPath = "res://assets/images/ui/aimer-3x.png"
		hotspot = Vector2(25, 25)
	elif windowSize.x / viewportSize.x >= 2:
		aimCursorPath = "res://assets/images/ui/aimer-2x.png"
		hotspot = Vector2(17, 17)
		
	var aimCursor = load(aimCursorPath)
	Input.set_custom_mouse_cursor(aimCursor, 0, hotspot)
	
	
func updateCoins(value):
	coins += value
	levelUi.updateCoins(coins)
	
	openMoneyDoors(coins)
	
	
func openMoneyDoors(coins):
	var moneyDoors = get_tree().get_nodes_in_group("money_door")
	for index in range(moneyDoors.size()):
		if coins >= moneyDoors[index].doorCost:
			moneyDoors[index].isOpen = true
		else:
			moneyDoors[index].isOpen = false
	
	
func _on_Root_size_changed():
	setCustomCursor()
	
	
func _on_Player_player_damaged():
	levelUi.updateHearts(player.hp, player.maxHp)
	camera.shakeCamera(3, 15.0)
	
	
func _on_Player_player_died():
	gun.queue_free()
	camera.shakeCamera(6, 80.0)
	

func _on_Gun_bullet_fired():
	var inst = BULLET_SCENE.instance()
	inst.transform = gun.transform
	inst.global_position = gun.bulletSpawnPos.global_position
	inst.moveDir = (get_global_mouse_position() - gun.global_position).normalized()
	inst.damage = bulletDamage
	inst.aimOffset = 5
	bulletWrap.add_child(inst)
	
	camera.shakeCamera(1, 15.0)
	
	
func _on_Enemy_enemy_died():
	camera.shakeCamera(2, 15.0)
	

func _on_Crate_loot_spawned(loot):
	if loot.is_in_group("coin"):
		loot.connect("coin_collected", self, "_on_Coin_coin_collected")
		
	if loot.is_in_group("heart_pickup"):
		loot.connect("heart_pickup_collected", self, "_on_HeartPickup_heart_pickup_collected")
		
		
func _on_Coin_coin_collected():
	updateCoins(1)
	
	
func _on_HeartPickup_heart_pickup_collected(area):
	if player.hp >= player.maxHp:
		return 
		
	area.queue_free()
	player.hp += 1
	levelUi.updateHearts(player.hp, player.maxHp)


func _on_DevConsole_command_inputted(command, value):
	cmdExe.call(cmdMgr.commandFunctionMap[command], value)
