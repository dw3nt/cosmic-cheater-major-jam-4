extends KinematicBody2D

signal player_damaged
signal player_died

const WHITE_FLASH_SHADER = preload("res://shaders/WhiteFlash.tres")

export(float) var moveSpeed = 150
export(float) var jumpForce = 200
export(float) var gravity = 8
export(int) var maxHp = 3
export(int) var maxFlash = 80

var velocity = Vector2.ZERO
var hp = maxHp
var flash = 0
var canBeHurt = true
var isInvincible = false
var isDead = false

onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var hurtboxCollider = $Hurtbox/CollisionShape2D


func _physics_process(delta):
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x *= moveSpeed
	
	if isDead:
		velocity.x = 0
	
	if !is_on_floor():
		velocity.y += gravity
	else:
		if Input.is_action_just_pressed("jump") && !isDead:
			velocity.y = -jumpForce
		else:
			velocity.y = gravity
		
	if !isDead:	
		if velocity.y < 0:
			animation.play("jump_up")
		elif velocity.y > gravity: 
			animation.play("jump_down")
		elif velocity.x != 0:
			animation.play("run")
		else:
			animation.play("idle")
		
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	move_and_slide(velocity, Vector2.UP)
	
	if flash > 0:
		flash -= 1
		if flash % 5 == 0:
			if sprite.material:
				sprite.material = null
			else:
				sprite.material = WHITE_FLASH_SHADER
	else:
		sprite.material = null
		canBeHurt = true


func _on_Hurtbox_body_entered(body):
	if !canBeHurt:
		return
	
	flash = maxFlash
	sprite.material = WHITE_FLASH_SHADER
	
	if !isInvincible:
		hp -= body.damage
		
	canBeHurt = false
	emit_signal("player_damaged")
	
	if hp <= 0:
		hurtboxCollider.set_deferred("disabled", true)
		animation.play("dead")
		emit_signal("player_died")
		isDead = true
