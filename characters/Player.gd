extends KinematicBody2D

signal player_damaged
signal player_died

const KNOCKBACK_AMOUNT = Vector2(120, -20)

export(float) var moveSpeed = 150
export(float) var jumpForce = 200
export(float) var gravity = 8
export(float) var friction = 10
export(int) var maxHp = 3
export(int) var maxFlash = 80

var velocity = Vector2.ZERO
var knockbackVelocity = Vector2.ZERO
var hp = maxHp
var canBeHurt = true
var isInvincible = false
var isDead = false
var damagingBodies = {}
var damagingBodiesOrder = []
var canAcceptInput = true
var inputX = 0
var wasOnFloor = true

onready var moveAnim = $MovementAnimation
onready var damageAnim = $DamageAnimation
onready var invincibleTimer = $InviniclbeTimer
onready var sprite = $Sprite
onready var hurtboxCollider = $Hurtbox/CollisionShape2D
onready var runningAudioTimer = $RunningAudio/RunTimer
onready var runningAudio = $RunningAudio
onready var jumpAudio = $JumpAudio
onready var hurtAudio = $HurtAudio
onready var deathAudio = $DeathAudio


func _ready():
	sprite.z_index = 0


func _physics_process(delta):
	if canAcceptInput && !isDead:
		inputX = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		
	velocity.x = inputX * moveSpeed
	
	if isDead:
		velocity.x = 0
	
	if !is_on_floor():
		velocity.y += gravity
		runningAudio.stop()
		runningAudioTimer.stop()
	else:
		if velocity.x != 0:
			if runningAudioTimer.is_stopped():
				runningAudioTimer.start()
				runningAudio.play()
		else:
			runningAudio.stop()
			runningAudioTimer.stop()
		
		if Input.is_action_just_pressed("jump") && !isDead && canAcceptInput:
			velocity.y = -jumpForce
			jumpAudio.play()
		else:
			velocity.y = gravity
			if !wasOnFloor && is_on_floor():
				runningAudio.play()
		
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
			
		
	velocity += knockbackVelocity
	knockbackVelocity = knockbackVelocity.move_toward(Vector2.ZERO, 10)
	
	wasOnFloor = is_on_floor()
	move_and_slide(velocity, Vector2.UP)
	
	
func applyDamage(damagingBody):
	if !canBeHurt:
		return
	
	invincibleTimer.start()
	knockbackVelocity = KNOCKBACK_AMOUNT
	knockbackVelocity.x *= sign(position.x - damagingBody.position.x)
	if position.y > damagingBody.position.y:
		knockbackVelocity.y *= -1
	
	if !isInvincible:
		hp -= damagingBody.damage
		
	canBeHurt = false
	emit_signal("player_damaged")
	
	if hp <= 0:
		hurtboxCollider.set_deferred("disabled", true)
		moveAnim.play("dead")
		deathAudio.play()
		emit_signal("player_died")
		isDead = true
		sprite.z_index = -10
	else:
		damageAnim.play("damaged")
		hurtAudio.play()


func _on_Hurtbox_body_entered(body):
	if !damagingBodies.has(body.name):
		damagingBodies[body.name] = body
		damagingBodiesOrder.append(body.name)
		
	applyDamage(body)
		
		
func _on_Hurtbox_body_exited(body):
	damagingBodies.erase(body.name)
	damagingBodiesOrder.remove(damagingBodiesOrder.find(body.name))


func _on_InviniclbeTimer_timeout():
	canBeHurt = true
	damageAnim.play("no_damage")
	
	if damagingBodies.size() > 0:
		applyDamage(damagingBodies[damagingBodiesOrder[damagingBodiesOrder.size() - 1]])


func _on_RunTimer_timeout():
	runningAudio.play()
