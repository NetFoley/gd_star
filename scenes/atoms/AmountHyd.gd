extends AtomAmount

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = GAME.connect("h_changed", self, "_on_amount_changed")

func _on_amount_changed(_amount) -> void:
	text = String("%.4f"%GAME.get_atom_tot("h"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
