extends Element
class_name Star

var temp : int = 4000000
var reaction_speed = 1

var atom_masses = {
	"h": 0.0,
	"he": 0.0,
	"c": 0.0,
	"ne": 0.0,
	"o": 0.0,
	"si": 0.0,
}

func is_class(value: String): return value == "Star" or .is_class(value)
func get_class() -> String: return "Star"

func _ready() -> void:
	var __ = connect("added_mass", self, "_added_mass")
	atom_masses["h"] = mass
	
	
func _added_mass(new_mass) -> void:
	GAME.emit_signal("camera_size_change", (element_size/3.0))

func _physics_process(_delta: float) -> void:
	for i in range(reaction_speed):
		_update_mass()
	_update_color()
	
func _on_collision(body) -> void:
	if !dead and !body.dead and (body.is_class("Star") and body.get_total_mass() >= get_total_mass()):
		explode()
		body.atom_masses["h"] += atom_masses["h"]
		body.atom_masses["he"] += atom_masses["he"]
		body.atom_masses["c"] += atom_masses["c"]
		body.atom_masses["ne"] += atom_masses["ne"]
		body.atom_masses["o"] += atom_masses["o"]
		body.atom_masses["si"] += atom_masses["si"]
		body.temp += temp
		atom_masses["h"] = 0.1
		atom_masses["he"] = 0.0
		atom_masses["c"] = 0.0
		atom_masses["ne"] = 0.0
		atom_masses["o"] = 0.0
		atom_masses["si"] = 0.0
		
func get_total_mass() -> float:
	return atom_masses["h"] + atom_masses["he"] + atom_masses["c"] + atom_masses["ne"] + atom_masses["o"] + atom_masses["si"]

func _update_mass() -> void:
	var mass_change = atom_masses["h"]*mass * 0.00001
	add_temp(mass_change*1000000000)
	add_temp(-temp*0.001)
	
	_fusion_atom_mass("h", mass_change)
	if(temp > 4000000):
		_fusion_atom_mass("he", mass_change)
	if(temp > 100000000):
		mass_change*= 0.8
		_fusion_atom_mass("c", mass_change)
	if(temp > 1000000000):
		mass_change*= 0.8
		_fusion_atom_mass("ne", mass_change)
	if(temp > 1200000000):
		mass_change*= 0.8
		_fusion_atom_mass("o", mass_change)
	if(temp > 2000000000):
		mass_change*= 0.8
		_fusion_atom_mass("si", mass_change)
	
	mass = get_total_mass()

func _fusion_atom_mass(atom, mass_change):
	var atom_change = mass_change
	atom_masses[atom] += atom_change
	
	#add_temp(-temp_suck)
	match(atom):
		"h":
			atom_masses["h"] -= atom_change*1.1
		"he":
			atom_masses["h"] -= atom_change
		"c":
			atom_masses["he"] -= atom_change
		"ne":
			atom_masses["c"] -= atom_change
		"o":
			atom_masses["ne"] -= atom_change
		"si":
			atom_masses["o"] -= atom_change
	
	GAME.emit_signal(atom+"_changed", atom_masses[atom])
	
func _update_color():
	var eff_temp = sqrt(float(temp/2))
	var r = max(0.0,min(1.0,inverse_lerp(15000, 3500, eff_temp)))
	var g = max(0.0,min(1.0,inverse_lerp(0, 5000, eff_temp)*r))
	var b = max(0.0,min(1.0,inverse_lerp(0, 5000, eff_temp)))
	var color = Color(r, g, b)
	var cols = []
	for i in 4:
		var new_col = color.darkened((i/4.0) * 0.9)
		new_col = new_col.lightened((1.0 - (i/4.0)) * 0.3)

		cols.append(new_col)
	cols[0] = cols[0].lightened(0.3)

	$Sprite2.set_colors([cols[0]] + cols + [cols[1], cols[0]])

func add_temp(tmp) -> void:
	temp += tmp
