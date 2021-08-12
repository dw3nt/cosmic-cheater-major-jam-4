extends Area2D

var damage = 999


func _on_PitDeathDetect_body_entered(body):
	body.isInvincible = false
	body.canBeHurt = true
	body.applyDamage(self)
