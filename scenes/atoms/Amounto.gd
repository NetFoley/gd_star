extends AtomAmount


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = GAME.connect("o_changed", self, "_on_amount_changed")

func _on_amount_changed(_amount) -> void:
	text = String("%.4f"%GAME.get_atom_tot("o"))
