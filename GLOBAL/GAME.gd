extends Node

var planet_ressource = preload("res://scenes/Planet.tscn")

signal element_selected
signal new_planet
signal camera_size_change

# Called when the node enters the scene tree for the first time.
func add_planet_at_cursor(planet) -> void:
	emit_signal("new_planet", planet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
