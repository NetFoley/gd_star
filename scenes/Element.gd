extends RigidBody2D
class_name Element

func is_class(value: String): return value == "Element" or .is_class(value)
func get_class() -> String: return "Element"

var element_size : float = sqrt(mass)

onready var suck_particles = $suckParticles

var attracted_bodies = []
var dead = false
onready var pm : ShaderMaterial = $suckParticles.process_material
onready var pm2 : ShaderMaterial = $ExplosionParticles.process_material

signal exploded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = $DragArea.connect("body_entered", self, "_on_body_drag_entered")
	__ = $DragArea.connect("body_exited", self, "_on_body_drag_exited")
	__ = connect("body_entered", self, "_on_collision")
	$CollisionShape2D.shape.radius = element_size * 5.0
	mass = pow(element_size, 2.0)
	$CollisionShape2D.shape = CircleShape2D.new()	
	_update_size()
	pm.set_shader_param("emition_radius", element_size*20.0)
	pm2.set_shader_param("emition_radius", element_size*30.0)

func _update_size() -> void:
	$CollisionShape2D.shape.radius = 25*element_size
	$Sprite.scale.x = (element_size*50.0) / $Sprite.texture.get_width()
	$Sprite.scale.y = (element_size*50.0) / $Sprite.texture.get_height()
	
func _on_collision(_body) -> void:
	explode()

func explode() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false
	sleeping = true
	dead = true
	$ExplosionParticles.emitting = true
	var tween = Tween.new()
	tween.interpolate_method($ExplosionParticles, "set_scale_to",
		10.0, 0.0, element_size,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#set_shader_param
	add_child(tween)
	tween.start()
	emit_signal("exploded", self)
	
func _on_body_drag_exited(body) -> void:
	attracted_bodies.erase(body)
	
func _on_attracted_exploded(body) -> void:
	attracted_bodies.erase(body)
	
func _on_body_drag_entered(body) -> void:
	if body != self and !body.dead:
		attracted_bodies.append(body)
		var __ = body.connect("exploded", self, "_on_attracted_exploded")

func _physics_process(delta: float) -> void:
	if attracted_bodies.size() == 0 or dead or is_class("Star"):
		$suckParticles.emitting = false;
	else:
		$suckParticles.emitting = true
	
	var closestBody : Element = null
	
	for body in attracted_bodies:
		if body.dead:
			continue
		if closestBody == null or position.distance_to(body.position) < position.distance_to(closestBody.position):
			closestBody = body
		var dist = position.distance_to(body.position)
		var dir = position.direction_to(body.position)
		var force = body.mass * 500000* mass * delta
		add_central_force(dir*(force / (dist*dist)))
		
	if is_instance_valid(closestBody):
		pm.set_shader_param("pos_attraction", closestBody.global_position)
		pm2.set_shader_param("pos_attraction", closestBody.global_position)
		pm.set_shader_param("initial_linear_velocity", linear_velocity.length())
		pm2.set_shader_param("initial_linear_velocity", linear_velocity.length())
		pm.set_shader_param("direction", linear_velocity.rotated((deg2rad(-rotation_degrees))))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
