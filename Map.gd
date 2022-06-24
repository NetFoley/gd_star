extends Node2D

onready var stars = get_tree().get_nodes_in_group("Star")
var hoveredElement = null
var selectedElement = null
var creatingElement = null
var mousePos = Vector2(0,0)
var grapPos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = GAME.connect("element_selected", self, "_on_element_selected")
	__ = GAME.connect("new_planet", self, "_on_new_planet")
	__ = GAME.connect("new_raw_planet", self, "_on_raw_new_planet")
	__ = GAME.connect("new_star_speed", self, "_on_new_star_speed")
	GAME.load_current_level()

func _on_new_star_speed(speed) -> void:
	for star in stars:
		if is_instance_valid(star):
			star.reaction_speed = speed
	
func _on_raw_new_planet(planet) -> void:
	planet.global_position = Vector2(0.0,0.0)
	$Space.add_child(planet)
	stars = get_tree().get_nodes_in_group("Star")
	
func _on_new_planet(planet) -> void:
	planet.global_position = get_global_mouse_position()
	creatingElement = planet
	$Space.add_child(planet)
	planet.deactivate()
	stars = get_tree().get_nodes_in_group("Star")
	
func _on_element_selected(element) -> void:
	hoveredElement = element
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("pick_element"):
		if is_instance_valid(selectedElement):
			pass
		selectedElement = null
		if is_instance_valid(creatingElement):
			creatingElement.activate()
		creatingElement = null
		
	if event.is_action_pressed("pick_element"):
		selectedElement = hoveredElement
		if is_instance_valid(selectedElement):
			grapPos = (mousePos - selectedElement.global_position).normalized()
		

func _physics_process(delta: float) -> void:
	mousePos = get_global_mouse_position()
	if is_instance_valid(creatingElement):
		creatingElement.global_position = mousePos
	if is_instance_valid(selectedElement):
		var dist = selectedElement.global_position.distance_to(mousePos)
		var dir = selectedElement.global_position.direction_to(mousePos)
		#selectedElement.add_central_force((selectedElement.global_position.direction_to(mousePos)* selectedElement.mass*100000)*delta)
		selectedElement.apply_impulse(grapPos,(dir* sqrt(selectedElement.mass)*dist*10)*delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
