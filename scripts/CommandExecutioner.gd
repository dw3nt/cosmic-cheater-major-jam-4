extends Node

var gameManager
var player
var gun
var enemyWrap


func _init(_gameManager, _player, _gun, _enemyWrap):
	gameManager = _gameManager
	player = _player
	gun = _gun
	enemyWrap = _enemyWrap
	

func updatePlayerJump(jumpValue):
	player.jumpForce = clamp(jumpValue, 1, 9999)
	GameManager.playerJump = player.jumpForce
	
	
func updatePlayerGravity(gravityValue):
	player.gravity = clamp(gravityValue, -999, 999)
	GameManager.playerGravity = player.gravity
	
	
func updatePlayerFireRate(fireRateValue):
	gun.shootCooldown = clamp(fireRateValue, 0.05, 999)
	GameManager.gunFireRate = gun.shootCooldown
	
	
func updatePlayerDamage(bulletDamageValue):
	GameManager.bulletDamage = clamp(bulletDamageValue, 0, 9999)
	
	
func updateEnemyGravity(gravityValue):
	for index in enemyWrap.get_child_count():
		enemyWrap.get_child(index).gravity = clamp(gravityValue, -999, 999)
		
	GameManager.enemyGravity = gravityValue
	
	
func disablePlayerHurtbox(value):
	player.isInvincible = true
	GameManager.isGodMode = true
	
	
func increaseMoney(coinValue):
	gameManager.updateCoins(coinValue * 100)
