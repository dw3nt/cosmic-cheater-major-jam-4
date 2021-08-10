extends Node

var commands = {
	# modifies specific properties on the player
		# eg: "player.jump=300"
	"playerJump": "player.jump=",
	"playerGravity": "player.gravity=",
	"playerFireRate": "player.fire_rate=",
	"playerDamage": "player.damage=",
	
	# changes gravity variable for ALL enemies makes them fly into the air
		# eg: "enemies.gravity=-200"
	"enemyGravity": "enemy.gravity=",
	
	# god mode
		# eg: "painkiller" disables player hurtbox
	"godMode": "painkiller",
	
	# add money per ! character (Sims reference)
		# eg: "rosebud!!!" gives 300 gold
	"addMoney": "rosebud!"
}

var commandOutputMap = {
	"playerJump" : "Player jump modified!",			
	"playerGravity": "Player gravity modified!",
	"playerFireRate": "Player fire rate modified!",
	"playerDamage": "Player damage modified!",
	
	"enemyGravity": "Enemy gravity modified!",	
	
	"godMode": "God Mode activated!",
	
	"addMoney": "Money added!"
}

var commandFunctionMap = {
	"playerJump" : "updatePlayerJump",			
	"playerGravity": "updatePlayerGravity",
	"playerFireRate": "updatePlayerFireRate",
	"playerDamage": "updatePlayerDamage",
	
	"enemyGravity": "updateEnemyGravity",	
	
	"godMode": "disablePlayerHurtbox",				
	
	"addMoney": "increaseMoney"
}


func parseCommandValue(command, input):
	match command:
		"playerJump", "playerGravity", "playerFireRate", "playerDamage", "enemyGravity":
			var equalPos = input.find("=")
			var value = input.substr(equalPos + 1)
			if value.is_valid_integer() || value.is_valid_float():
				return float(value)
			else:
				return null
			
		"addMoney":
			var count = input.countn("!")
			if count <= 0:
				return null
			else:
				return count
			
		"godMode":
			return 0
