extends VBoxContainer


func _ready() -> void:
	var __ = $Reactionspeed.connect("value_changed", self, "_update_value")
	__ = GAME.connect("level_loaded", self, "_on_level_loaded")
	_update_value($Reactionspeed.value)

func _on_level_loaded():
	_update_value(1)
	
func _update_value(new_value):
	$Vit.text = "Reaction speed: " + String(new_value)
	GAME.emit_signal("new_star_speed", new_value)
