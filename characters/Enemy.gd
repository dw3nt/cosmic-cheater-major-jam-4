extends KinematicBody2D

signal enemy_died

const ENEMEY_DEAD_SCENE = preload("res://characters/EnemyDead.tscn")

export(float) var moveSpeed = 75
export(float) var jumpForce = 200
export(float) var gravity = 8
export(int) var maxHp = 2
export(int) var damage = 1
export(int) var moveDir = 0

var velocity = Vector2.ZERO
var hp

onready var moveAnim = $MovementAnimation
onready var damageAnim = $DamageAnimation
onready var sprite = $Sprite
onready var forwardRay = $ForwardRay
onready var flashTimer = $FlashTimer
onready var hurtAudio = $HurtAudio


func _ready():
	randomize()
	if moveDir == 0:
		moveDir = sign(rand_range(-1, 1))
	forwardRay.cast_to.x *= moveDir
	hp = maxHp


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
		moveAnim.play("run")
		
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	move_and_slide(velocity, Vector2.UP)	


func _on_Hurtbox_body_entered(body):
	hp -= body.damage
	damageAnim.play("damaged")
	flashTimer.start()
		
	if hp <= 0:
		var inst = ENEMEY_DEAD_SCENE.instance()
		inst.position = position
		inst.moveDir = sign(position.x - body.position.x)
		get_parent().call_deferred("add_child", inst)
		emit_signal("enemy_died")
		queue_free()
	else:
		hurtAudio.play()
	
	if body.is_in_group("bullet"):
		body.queue_free()


func _on_FlashTimer_timeout():
	damageAnim.play("no_damage")
