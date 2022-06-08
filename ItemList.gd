extends ItemList


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_item("0.01", load("res://images/Yalup VI 75b6b9a4.png"))
	add_item("0.05", load("res://images/Yalup VI 75b6b9a4.png"))
	add_item("0.1", load("res://images/Yalup VI 75b6b9a4.png"))
	add_item("0.5", load("res://images/Yalup VI 75b6b9a4.png"))
	add_item("1.0", load("res://images/Yalup VI 75b6b9a4.png"))
	var __ = connect("item_selected", self, "_create_planet")
	__ = $HSlider.connect("value_changed", self, "_update_value")
	set_allow_reselect(true)

func _update_value(new_value):
	set_item_text(get_item_count()-1, String(new_value))
	
func _create_planet(item):
	var planet = GAME.planet_ressource.instance()
	planet.mass = float(get_item_text(item))
	planet.global_position = get_global_mouse_position()
	GAME.add_planet_at_cursor(planet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
