extends Node2D

const BULLET_SCENE = preload("res://weapon/Bullet.tscn")
const COIN_SCENE = preload("res://objects/Coin.tscn")

var coins = 0

onready var player = $Player
onready var gun = $Gun
onready var bulletWrap = $BulletWrap
onready var crateWrap = $CrateWrap
onready var ui = $UIWrap/UI


func _ready():
	get_tree().get_root().connect("size_changed", self, "_on_Root_size_changed")
	setCustomCursor()
	
	player.connect("player_damaged", self, "_on_Player_player_damaged")
	gun.connect("bullet_fired", self, "_on_Gun_bullet_fired")
	
	ui.updateHearts(player.hp, player.maxHp)
	ui.updateCoins(coins)
	
	for index in range(crateWrap.get_child_count()):
		crateWrap.get_child(index).connect("loot_spawned", self, "_on_Crate_loot_spawned")
	
	
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
	
	
func _on_Root_size_changed():
	setCustomCursor()
	
	
func _on_Player_player_damaged():
	ui.updateHearts(player.hp, player.maxHp)
	

func _on_Gun_bullet_fired():
	var inst = BULLET_SCENE.instance()
	inst.transform = gun.transform
	inst.global_position = gun.bulletSpawnPos.global_position
	inst.moveDir = (get_global_mouse_position() - gun.global_position).normalized()
	bulletWrap.add_child(inst)
	

func _on_Crate_loot_spawned(loot):
	if loot.is_in_group("coin"):
		loot.connect("coin_collected", self, "_on_Coin_coin_collected")
		
		
func _on_Coin_coin_collected():
	coins += 1
	ui.updateCoins(coins)
