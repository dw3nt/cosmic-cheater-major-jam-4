extends Node

var devConsoleEnabled = false
var cameraShakeEnabled = true

var playerSpawnLookUpNode = null

var playerHp = null

# cheat codes
var playerJump = null
var playerGravity = null
var gunFireRate = null
var bulletDamage = null

var enemyGravity = null

var isGodMode = false

var playerCoinAmount = 0
var coinsCollected = {}
var heartsCollected = {}
var cratesLooted = {}


func resetSaveData():
	playerSpawnLookUpNode = null
	playerHp = null
	playerJump = null
	playerGravity = null
	gunFireRate = null
	bulletDamage = null
	enemyGravity = null
	isGodMode = false
	playerCoinAmount = 0
	coinsCollected = {}
	heartsCollected = {}
	cratesLooted = {}
