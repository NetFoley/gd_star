extends Camera2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = GAME.connect("camera_size_change", self, "_on_new_size")

func _on_new_size(new_size) -> void:
	zoom.x = new_size
	zoom.y = new_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
