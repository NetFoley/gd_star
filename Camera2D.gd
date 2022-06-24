extends Camera2D


# Called when the node enters the scene tree for the first time.

func _physics_process(_delta: float) -> void:
	var star_follow = null
	for star in get_tree().get_nodes_in_group("Star"):
		if star_follow == null or star.atom_masses["h"] > star_follow.atom_masses["h"]:
			star_follow = star
	if !is_instance_valid(star_follow):
		return
	set_position(star_follow.position)
	
	var new_size = star_follow.element_size/3.0
	
	zoom.x = new_size
	zoom.y = new_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
