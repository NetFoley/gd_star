extends ItemList


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = connect("item_selected", self, "_create_planet")
	set_allow_reselect(true)
	
func load_planets(planets):
	for planet in planets:
		add_item(planet, load("res://images/Yalup VI 75b6b9a4.png"))

func _create_planet(item):
	var mass = float(get_item_text(item))
	GAME.add_planet_at_cursor(mass)
	remove_item(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
