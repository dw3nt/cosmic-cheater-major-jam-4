extends Node2D

signal room_ready
signal room_change_requested

const CMD_EXE_SCRIPT = preload("res://scripts/CommandExecutioner.gd")

const MAIN_MENU_SCENE = "res://menus/MainMenu.tscn"
const BULLET_SCENE = preload("res://weapon/Bullet.tscn")
const COIN_SCENE = preload("res://objects/Coin.tscn")

export(String, FILE, "*.tscn") var restartScene

var cmdMgr = load("res://scripts/CommandManager.gd").new()
var cmdExe
var saveFile = FileDataManager.new("user://save_data.data")
var settingsFile = FileDataManager.new("user://settings_data.data")

var coins = 0
var coinsCollectedPaths = []
var heartsCollectedPaths = []
var crateStates = {}

onready var player = $Player
onready var camera = $Player/Camera
onready var gun = $Player/Gun
onready var bulletWrap = $BulletWrap
onready var enemyWrap = $EnemyWrap
onready var crateWrap = $CrateWrap
onready var coinWrap = $CoinWrap
onready var heartWrap = $HeartWrap
onready var levelUi = $UIWrap/LevelUi
onready var devConsole = $UIWrap/DevConsole
onready var deathMenu = $UIWrap/PlayerDeathMenu
onready var deathMenuTimer = $DeathMenuTimer


func _init():
	add_user_signal("music_change_requested")


func _ready():
	if !restartScene:
		restartScene = filename
		
	loadSaveData()
	var sl = SettingsLoader.new()
	sl.loadSettingsData()
		
	cmdExe = CMD_EXE_SCRIPT.new(self, player, gun, enemyWrap)
	
	get_tree().get_root().connect("size_changed", self, "_on_Root_size_changed")
	setCustomCursor()
	
	if GameManager.playerSpawnLookUpNode:
		var spawnPosNode = get_node(GameManager.playerSpawnLookUpNode)
		player.global_position = spawnPosNode.global_position
		player.sprite.flip_h = spawnPosNode.global_position.x < spawnPosNode.get_parent().global_position.x
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
	
	for index in range(enemyWrap.get_child_count()):
		var currentEnemy = enemyWrap.get_child(index)
		currentEnemy.connect("enemy_died", self, "_on_Enemy_enemy_died")
		if GameManager.enemyGravity:
			currentEnemy.gravity = GameManager.enemyGravity
	
	for index in range(crateWrap.get_child_count()):
		var currentCrate = crateWrap.get_child(index)
		currentCrate.connect("loot_spawned", self, "_on_Crate_loot_spawned")
		if GameManager.cratesLooted.keys().has(filename) && GameManager.cratesLooted[filename].has(currentCrate.get_path()):
			if GameManager.cratesLooted[filename][currentCrate.get_path()] == CrateStates.States.DESTROYED:
				currentCrate.call_deferred("spawnLoot")
				currentCrate.call_deferred("queue_free")
			elif GameManager.cratesLooted[filename][currentCrate.get_path()] == CrateStates.States.LOOTED:
				currentCrate.call_deferred("queue_free")
		
		
	updateCoins(GameManager.playerCoinAmount)
	
	for index in range(coinWrap.get_child_count()):
		var currentCoin = coinWrap.get_child(index)
		if GameManager.coinsCollected.keys().has(filename) && GameManager.coinsCollected[filename].has(currentCoin.get_path()):
			currentCoin.queue_free()
		else:
			currentCoin.connect("coin_collected", self, "_on_Coin_coin_collected")
			
	for index in range(heartWrap.get_child_count()):
		var currentHeart = heartWrap.get_child(index)
		if GameManager.heartsCollected.keys().has(filename) && GameManager.heartsCollected[filename].has(currentHeart.get_path()):
			currentHeart.queue_free()
		else:
			currentHeart.connect("heart_pickup_collected", self, "_on_HeartPickup_heart_pickup_collected")
		
	yield(get_tree().create_timer(0.25), "timeout")
	emit_signal("room_ready")
	emit_signal("music_change_requested", "res://assets/sounds/game_music.ogg")
	
	
func loadSaveData():
	var playerHp = saveFile.readValue("playerHp")
	if playerHp:
		GameManager.playerHp = playerHp
		
	var playerCoins = saveFile.readValue("coins")
	if playerCoins:
		GameManager.playerCoinAmount = playerCoins
		
	var roomSpawnPos = saveFile.readValue("playerRoomSpawn")
	if roomSpawnPos:
		GameManager.playerSpawnLookUpNode = roomSpawnPos
		
	var coinsCollected = saveFile.readValue("coinsCollected")
	if coinsCollected:
		GameManager.coinsCollected = coinsCollected
		
	var heartsCollected = saveFile.readValue("heartsCollected")
	if heartsCollected:
		GameManager.heartsCollected = heartsCollected
		
	var levelCrateStates = saveFile.readValue("crateStates")
	if levelCrateStates:
		GameManager.cratesLooted = levelCrateStates
		
	
	
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
			
			
func restartLevel():
	emit_signal("room_change_requested", { "scene": restartScene, "transition": "SwipeToMiddle" })
	
	
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
	restartLevel()
	
	
func _on_PauseMenu_restart_pressed():
	restartLevel()
	

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
	crateStates[loot.cratePath] = CrateStates.States.DESTROYED
	
	if loot.is_in_group("coin"):
		loot.connect("coin_collected", self, "_on_Coin_coin_collected")
		
	if loot.is_in_group("heart_pickup"):
		loot.connect("heart_pickup_collected", self, "_on_HeartPickup_heart_pickup_collected")
		
		
func _on_Coin_coin_collected(coin):
	coinsCollectedPaths.append(coin.get_path())
	if coin.cratePath:
		crateStates[coin.cratePath] = CrateStates.States.LOOTED
		
	updateCoins(1)
	
	
func _on_HeartPickup_heart_pickup_collected(area):
	if player.hp >= player.maxHp:
		return
		
	area.visible = false
	area.collider.set_deferred("disabled", true)
	area.collectedAudio.play()
		
	heartsCollectedPaths.append(area.get_path())
	if area.cratePath:
		crateStates[area.cratePath] = CrateStates.States.LOOTED
		
	player.hp += 1
	levelUi.updateHearts(player.hp, player.maxHp)
	
	yield(area.collectedAudio, "finished")
	area.queue_free()


func _on_DevConsole_command_inputted(command, value):
	cmdExe.call(cmdMgr.commandFunctionMap[command], value)


func _on_DeathMenuTimer_timeout():
	deathMenu.enter()


func _on_LevelTransitioner_level_change_requested(transitioner, nextScene):
	GameManager.playerCoinAmount = coins
	if !GameManager.coinsCollected.has(filename):
		GameManager.coinsCollected[filename] = []
	GameManager.coinsCollected[filename] += coinsCollectedPaths
	
	if !GameManager.heartsCollected.has(filename):
		GameManager.heartsCollected[filename] = []
	GameManager.heartsCollected[filename] += heartsCollectedPaths
	
	for index in range(crateStates.keys().size()):
		if !GameManager.cratesLooted.keys().has(filename):
			GameManager.cratesLooted[filename] = {}	
		
		GameManager.cratesLooted[filename][crateStates.keys()[index]] = crateStates[crateStates.keys()[index]]
		
	GameManager.playerHp = player.hp
	
	player.canAcceptInput = false
	
	if transitioner.is_in_group("next_level_transitioner"):
		GameManager.playerSpawnLookUpNode = NodePath("PreviousLevelTransitioner/SpawnPosition")
	else:
		GameManager.playerSpawnLookUpNode = NodePath("NextLevelTransitioner/SpawnPosition")
		
	saveFile.writeValue("levelPath", nextScene)
	saveFile.writeValue("playerHp", player.hp)
	saveFile.writeValue("coins", GameManager.playerCoinAmount)
	saveFile.writeValue("coinsCollected", GameManager.coinsCollected)
	saveFile.writeValue("heartsCollected", GameManager.heartsCollected)
	saveFile.writeValue("crateStates", GameManager.cratesLooted)
	saveFile.writeValue("playerRoomSpawn", GameManager.playerSpawnLookUpNode)
		
	emit_signal("room_change_requested", { "scene": nextScene, "transition": "SwipeToMiddle" })


func _on_PauseMenu_main_menu_pressed():
	emit_signal("room_change_requested", { "scene": MAIN_MENU_SCENE, "transition": "SwipeToMiddle" })
