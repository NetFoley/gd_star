extends Label

onready var timer = $Timer
var time_left = 10.0
var sped = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = GAME.connect("level_loaded", self, "_on_level_loaded")
	__ = GAME.connect("new_star_speed", self, "_on_reaction_speed_changed")
	
func _on_reaction_speed_changed(new_sp) -> void:
	sped = new_sp
	
func _on_level_loaded() -> void:
	set_time(GAME.time)
	
func set_time(time) -> void:
	time_left = time

func _physics_process(delta: float) -> void:
	time_left -= delta * float(sped)
	text = "Temps restant : " + String("%.2f"%time_left)
	if time_left <= 0.0:
		GAME.reload_level()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
