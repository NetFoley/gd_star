extends Element
class_name Star

func is_class(value: String): return value == "Star" or .is_class(value)
func get_class() -> String: return "Star"

func _ready() -> void:
	var __ = connect("added_mass", self, "_added_mass")
	
func _added_mass(new_mass) -> void:
	GAME.emit_signal("camera_size_change", sqrt(element_size))
