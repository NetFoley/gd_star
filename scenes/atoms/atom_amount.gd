extends Label
class_name AtomAmount


# Called when the node enters the scene tree for the first time.
func _on_amount_changed(new_amount) -> void:
	text = String("%.4f"%new_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
