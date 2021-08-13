extends Node2D

signal room_ready
signal room_change_requested

const CMD_EXE_SCRIPT = preload("res://scripts/CommandExecutioner.gd")

const BULLET_SCENE = preload("res://weapon/Bullet.tscn")
const COIN_SCENE = preload("res://objects/Coin.tscn")

export(String, FILE, "*.tscn") var restartScene

var cmdMgr = load("res://scripts/CommandManager.gd").new()
var cmdExe

var bulletDamage = 1
var coins = 0

onready var player = $Player
onready var camera = $Player/Camera
onready var gun = $Player/Gun
onready var bulletWrap = $BulletWrap
onready var enemyWrap = $EnemyWrap
onready var crateWrap = $CrateWrap
onready var coinWrap = $CoinWrap
onready var levelUi = $UIWrap/LevelUi
onready var devConsole = $UIWrap/DevConsole
onready var deathMenu = $UIWrap/PlayerDeathMenu
onready var deathMenuTimer = $DeathMenuTimer


func _ready():
	if !restartScene:
		restartScene = filename
		
	cmdExe = CMD_EXE_SCRIPT.new(self, player, gun, enemyWrap)
	
	get_tree().get_root().connect("size_changed", self, "_on_Root_size_changed")
	setCustomCursor()
	
	if GameManager.playerSpawnLookUpNode:
		player.global_position = get_node(GameManager.playerSpawnLookUpNode).global_position
	else:
		player.global_position = $PreviousLevelTransitioner/SpawnPosition.global_position
		
	loadPlayerCheats()
	
	player.connect("player_damaged", self, "_on_Player_player_damaged")
	player.connect("player_died", self, "_on_Player_player_died")
	gun.connect("bullet_fired", self, "_on_Gun_bullet_fired")
	
	if GameManager.playerHp:
		player.hp = GameManager.playerHp
	
	levelUi.updateHearts(player.hp, player.maxHp)
	levelUi.updateCoins(coins)
	deathMenu.connect("restart_pressed", self, "_on_PlayerDeathMenu_restart_pressed")
	
	for index in range(enemyWrap.get_child_count()):
		var currentEnemy = enemyWrap.get_child(index)
		currentEnemy.connect("enemy_died", self, "_on_Enemy_enemy_died")
		if GameManager.enemyGravity:
			currentEnemy.gravity = GameManager.enemyGravity
	
	for index in range(crateWrap.get_child_count()):
		crateWrap.get_child(index).connect("loot_spawned", self, "_on_Crate_loot_spawned")
		
	updateCoins(GameManager.playerCoinAmount)
	
	for index in range(coinWrap.get_child_count()):
		coinWrap.get_child(index).connect("coin_collected", self, "_on_Coin_coin_collected")
		
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
	
	
func loadPlayerCheats():
	if GameManager.playerJump:
		player.jumpForce = GameManager.playerJump
		
	if GameManager.playerGravity:
		player.gravity = GameManager.playerGravity
		
	if GameManager.gunFireRate:
		gun.shootCooldown = GameManager.gunFireRate
		
	player.isInvincible = GameManager.isGodMode
	
	
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
	camera.shakeCamera(4, 0.3)
	
	
func _on_Player_player_died():
	gun.queue_free()
	camera.shakeCamera(6, 1.5)
	deathMenuTimer.start()
	

func _on_PlayerDeathMenu_restart_pressed():
	emit_signal("room_change_requested", { "scene": restartScene, "transition": "SwipeToMiddle" })
	

func _on_Gun_bullet_fired():
	var inst = BULLET_SCENE.instance()
	inst.transform = gun.transform
	inst.global_position = gun.bulletSpawnPos.global_position
	inst.moveDir = (get_global_mouse_position() - gun.global_position).normalized()
	if GameManager.bulletDamage:
		inst.damage = GameManager.bulletDamage
	inst.aimOffset = 5
	bulletWrap.add_child(inst)
	
	camera.shakeCamera(2, 0.25)
	
	
func _on_Enemy_enemy_died():
	camera.shakeCamera(3, 0.25)
	

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


func _on_DeathMenuTimer_timeout():
	deathMenu.enter()


func _on_LevelTransitioner_level_change_requested(transitioner, nextScene):
	player.canAcceptInput = false
	
	GameManager.playerCoinAmount = coins
	GameManager.playerHp = player.hp
	
	if transitioner.is_in_group("next_level_transitioner"):
		GameManager.playerSpawnLookUpNode = NodePath("PreviousLevelTransitioner/SpawnPosition")
	else:
		GameManager.playerSpawnLookUpNode = NodePath("NextLevelTransitioner/SpawnPosition")
		
	emit_signal("room_change_requested", { "scene": nextScene, "transition": "SwipeToMiddle" })
