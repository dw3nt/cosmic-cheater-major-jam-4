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
	player.jumpForce = jumpValue
	
	
func updatePlayerGravity(gravityValue):
	player.gravity = gravityValue
	
	
func updatePlayerFireRate(fireRateValue):
	gun.shootCooldown = fireRateValue
	
	
func updatePlayerDamage(bulletDamageValue):
	gameManager.bulletDamage = bulletDamageValue
	
	
func updateEnemyGravity(gravityValue):
	for index in enemyWrap.get_child_count():
		enemyWrap.get_child(index).gravity = gravityValue
	
	
func disablePlayerHurtbox(value):
	player.isInvincible = true
	
	
func increaseMoney(coinValue):
	gameManager.updateCoins(coinValue * 100)
