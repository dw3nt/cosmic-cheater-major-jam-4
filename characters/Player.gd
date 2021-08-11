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
var canBeHurt = true
var isInvincible = false
var isDead = false

onready var moveAnim = $MovementAnimation
onready var damageAnim = $DamageAnimation
onready var invincibleTimer = $InviniclbeTimer
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
			moveAnim.play("jump_up")
		elif velocity.y > gravity: 
			moveAnim.play("jump_down")
		elif velocity.x != 0:
			moveAnim.play("run")
		else:
			moveAnim.play("idle")
		
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	move_and_slide(velocity, Vector2.UP)


func _on_Hurtbox_body_entered(body):
	if !canBeHurt:
		return
	
	damageAnim.play("damaged")
	invincibleTimer.start()
	
	if !isInvincible:
		hp -= body.damage
		
	canBeHurt = false
	emit_signal("player_damaged")
	
	if hp <= 0:
		hurtboxCollider.set_deferred("disabled", true)
		moveAnim.play("dead")
		emit_signal("player_died")
		isDead = true


func _on_InviniclbeTimer_timeout():
	canBeHurt = true
	damageAnim.play("no_damage")
