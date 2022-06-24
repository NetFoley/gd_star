extends Node

var planet_ressource = preload("res://scenes/Planet.tscn")
var star_ressource = preload("res://scenes/Star.tscn")

signal element_selected
signal new_planet
signal new_raw_planet
signal camera_size_change
signal new_star_speed
signal level_loaded

var h_total = 0.0
var he_total = 0.0
var c_total = 0.0
var ne_total = 0.0
var o_total = 0.0
var si_total = 0.0

signal h_changed
signal he_changed
signal c_changed
signal ne_changed
signal o_changed
signal si_changed

var planets = []
var goal = []
var stars = []
var time = 1.0
var level = 0
var level_prop = []

var reaction_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_prop.append([["0.1","0.15", "0.25", "0.5"], ["1.0","he"], ["1.0"], 1000.0])
	level_prop.append([["0.1","0.15", "0.25", "0.5", "1.0", "2.0", "5.0"], ["5.0","c"], ["2.0"], 4200.0])
	level_prop.append([["0.1","0.15", "0.25", "0.5", "1.0", "2.0", "5.0", "5.0", "3.0"], ["10.0","c"], ["2.0"], 2000.0])
	level_prop.append([["0.2","1.15", "2.0", "2.0", "5.0", "5.0", "10.0", "10.0"], ["20.0","c"], ["2.0"], 400.0])
	
func reload_level():
	load_current_level()

func next_level():
	level += 1
	load_current_level()

func load_current_level():
	if level >= level_prop.size():
		print("Last level achieved")
		return
		
	planets = level_prop[level][0]
	goal = level_prop[level][1]
	stars = level_prop[level][2]
	time = level_prop[level][3]
	
	var time_el = get_tree().get_nodes_in_group("time")
	time_el[0].set_time(time)
	var space = get_tree().get_nodes_in_group("space")
	var elements = space[0].get_children()
	for element in elements:
		space[0].remove_child(element)
	var sac = get_tree().get_nodes_in_group("sac")
	sac[0].clear()
	sac[0].load_planets(planets)
	for star in stars:
		add_planet(float(star))
	get_tree().get_nodes_in_group("level_label")[0].set_text("Niveau " + String(level+1))
	emit_signal("level_loaded")
	
func set_reaction_speed(spe):
	reaction_speed = spe
	emit_signal("new_star_speed", reaction_speed)
	
func add_planet(mass) -> void:
	var planet = null
	if mass >= 0.3:
		planet = star_ressource.instance()
	else:
		planet = planet_ressource.instance()
	planet.mass = mass
	emit_signal("new_raw_planet", planet)
	
	
func add_planet_at_cursor(mass) -> void:
	var planet = null
	if mass >= 0.3:
		planet = star_ressource.instance()
	else:
		planet = planet_ressource.instance()
	planet.mass = mass
	emit_signal("new_planet", planet)
	
func win_level():
	next_level()
	
func get_atom_tot(atom) -> float:
	var starss = get_tree().get_nodes_in_group("Star")
	var tot = 0.0
	for star in starss:
		if !star.dead:
			tot += star.atom_masses[atom]
	if atom == goal[1]:
		if tot >= float(goal[0]):
			win_level()
	return tot
	
