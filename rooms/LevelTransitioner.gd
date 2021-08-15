extends Area2D

signal level_change_requested

export(String, FILE, "*.tscn") var transitionToScene
export(String) var spawnNodeName


func _on_LevelTransitioner_body_entered(body):
	if transitionToScene:
		emit_signal("level_change_requested", self, transitionToScene)
