extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = GAME.connect("level_loaded", self, "_on_lvl_loaded")

func _on_lvl_loaded():
	text = "Objectif : " + GAME.goal[0] + " " + GAME.goal[1]
