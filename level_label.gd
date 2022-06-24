extends RichTextLabel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func set_text(t):
	bbcode_text = "\n[wave amp=50 freq=2]" + t + "[/wave]"
	$AnimationPlayer.play("disappear")
	
