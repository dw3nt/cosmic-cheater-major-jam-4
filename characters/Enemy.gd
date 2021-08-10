extends KinematicBody2D

const WHITE_FLASH_SHADER = preload("res://shaders/WhiteFlash.tres")
const ENEMEY_DEAD_SCENE = preload("res://characters/EnemyDead.tscn")

export(float) var moveSpeed = 75
export(float) var jumpForce = 200
export(float) var gravity = 8
export(int) var maxFlash = 3
export(int) var maxHp = 2

var velocity = Vector2.ZERO
var moveDir = 0
var flash = 0
var hp = maxHp

onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var forwardRay = $ForwardRay

func _ready():
	moveDir = sign(rand_range(-1, 1))
	forwardRay.cast_to.x *= moveDir


func _physics_process(delta):
	if forwardRay.is_colliding():
		moveDir *= -1
		forwardRay.cast_to.x *= -1
	
	velocity.x = moveSpeed * moveDir
	
	if !is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = gravity
	
	if velocity.x != 0:
		animation.play("run")
		
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	move_and_slide(velocity, Vector2.UP)
	
	if flash > 0:
		flash -= 1
	else:
		sprite.material = null		


func _on_Hurtbox_body_entered(body):
	flash = maxFlash
	sprite.material = WHITE_FLASH_SHADER
	hp -= body.damage
	if hp <= 0:
		var inst = ENEMEY_DEAD_SCENE.instance()
		inst.position = position
		inst.moveDir = sign(position.x - body.position.x)
		get_parent().call_deferred("add_child", inst)
		queue_free()
	
	body.queue_free()
