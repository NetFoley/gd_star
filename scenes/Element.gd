extends RigidBody2D
class_name Element

func is_class(value: String): return value == "Element" or .is_class(value)
func get_class() -> String: return "Element"

var element_size : float  = 1.0
export var size_factor : float  = 0.33
export var stuck = false

onready var suck_particles = $suckParticles

var attracted_bodies = []
var dead = false
onready var pm : ShaderMaterial = $suckParticles.process_material
onready var pm2 : ShaderMaterial = $ExplosionParticles.process_material

signal exploded
signal added_mass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = $DragArea.connect("body_entered", self, "_on_body_drag_entered")
	__ = $DragArea.connect("body_exited", self, "_on_body_drag_exited")
	__ = connect("body_entered", self, "_on_collision")
	$CollisionShape2D.shape = CircleShape2D.new()	
	$ClickArea/ClickShape.shape = CircleShape2D.new()	
	_update_size()
	set_stuck(stuck)
	__ = $Sprite2.connect("mouse_entered", self, "_mouse_entered_element")
	__ = $Sprite2.connect("mouse_exited", self, "_mouse_exited_element")
	__ = $Timer.connect("timeout", self, "_on_timeout")
	var color = $Sprite2.get_colors()[0]
	pm.set_shader_param("color_value", color)
	pm2.set_shader_param("color_value", color)

func _mouse_entered_element() -> void:
	GAME.emit_signal("element_selected", self)
	
func _mouse_exited_element() -> void:
	GAME.emit_signal("element_selected", null)

func _on_timeout() -> void:
	queue_free()
	
func add_mass(qty) -> void:
	mass += qty
	_update_size()
	
	emit_signal("added_mass", mass)

func set_stuck(value) -> void:
	stuck = value
	sleeping = value

func _update_size() -> void:
	element_size = pow(mass*1000.0,size_factor)
	var element_radius = 25.0*element_size
	$CollisionShape2D.shape.radius = element_radius
	$ClickArea/ClickShape.shape.radius = element_radius
	pm.set_shader_param("emition_radius", element_size*10.0)
	pm2.set_shader_param("emition_radius", element_size*10.0)
	$Sprite2.set_position(Vector2(-element_size * 25.0, -element_size * 25.0))
	$Sprite2.set_scale(Vector2(0.5, 0.5))
	$Sprite2.set_pixels(element_radius*4)
	pm2.set_shader_param("initial_linear_velocity", sqrt(element_size*50000.0))
	
		
func _on_collision(body) -> void:
	if !dead and !body.dead: 
		if (body.is_class("Star")):
			explode()
			body.atom_masses['h'] += mass
		elif(body.mass >= mass):
			explode()
			body.add_mass(mass)

func deactivate() -> void:
	dead = true
	$CollisionShape2D.disabled = true
	$Sprite2.set_modulate(Color(1.0,1.0,1.0,0.35))
	sleeping = true

func activate() -> void:
	dead = false
	$CollisionShape2D.disabled = false
	$Sprite2.set_modulate(Color(1.0,1.0,1.0,1.0))
	sleeping = false

func explode() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2.visible = false
	
	sleeping = true
	dead = true
	
	$ExplosionParticles.emitting = true
	var duration_left = sqrt(element_size*2.0+1.0)
	
	var tween = Tween.new()
	tween.interpolate_method($ExplosionParticles, "set_scale_to",
		sqrt(element_size), 0.0, duration_left,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#set_shader_param
	add_child(tween)
	tween.start()
	var tween2 = Tween.new()
	tween2.interpolate_method($suckParticles, "set_scale_to",
		1, 0.0, duration_left,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#set_shader_param
	add_child(tween2)
	tween2.start()
	
	$Timer.start(duration_left)
	
	emit_signal("exploded", self)
	
func _on_body_drag_exited(body) -> void:
	if body != self and attracted_bodies.has(body):
		attracted_bodies.erase(body)
		var __ = body.disconnect("exploded", self, "_on_attracted_exploded")
	
func _on_attracted_exploded(body) -> void:
	attracted_bodies.erase(body)
	
func _on_body_drag_entered(body) -> void:
	if body != self and !body.dead and !attracted_bodies.has(body):
		attracted_bodies.append(body)
		var __ = body.connect("exploded", self, "_on_attracted_exploded")

func _physics_process(_delta: float) -> void:
	if stuck:
		return
	if attracted_bodies.size() == 0 or dead:
		$suckParticles.emitting = false;
	else:
		$suckParticles.emitting = true
	
	var closestBody = null
	var max_force = 0.0
	for body in attracted_bodies:
		if body.dead:
			continue
		var dist = max(1.0, position.distance_to(body.position))
		var dir = position.direction_to(body.position)
		var force = body.mass * mass * 100.0
		if body.is_class("Star") and (closestBody == null or force > max_force):
			closestBody = body
			max_force = force
		apply_central_impulse(dir*(force / (pow(dist,0.5)))*_delta*10)
		
		
	if is_instance_valid(closestBody):
		var dir = global_position.direction_to(closestBody.global_position)
		var dist = clamp(global_position.distance_to(closestBody.global_position)*0.001, 0.0, 1.0) 
		$Sprite2.set_light((dir.rotated(deg2rad(-rotation_degrees))*dist*0.5)+Vector2(0.5,0.5))
		pm.set_shader_param("pos_attraction", closestBody.global_position)
		pm2.set_shader_param("pos_attraction", closestBody.global_position)
		pm.set_shader_param("initial_linear_velocity", linear_velocity.length())
		pm.set_shader_param("direction", linear_velocity.rotated((deg2rad(-rotation_degrees))))
		pm2.set_shader_param("second_initial_linear_velocity", linear_velocity)
		pm.set_shader_param("part_distance", (closestBody.element_size*element_size)*10000.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
