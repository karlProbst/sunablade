extends RigidBody

onready var rf = get_tree().get_current_scene().get_node("vc/v/beyblade2/r/rf")
onready var rb = get_tree().get_current_scene().get_node("vc/v/beyblade2/r/rb")
onready var rff= get_tree().get_current_scene().get_node("vc/v/beyblade2/r/rff")
onready var r = get_tree().get_current_scene().get_node("vc/v/beyblade2/r")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var alive = true
var forward = Vector3(0,0,1)
var rot = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.get_mode())
	self.set_mode(2)
#	self.apply_impulse(Vector3(0, 0,0),Vector3(randi(),randi(),randi()))
	
func _integrate_forces(state):
	if(alive):
		if(self.translation.y>30):
			self.linear_velocity.y = -25
		if rff.is_colliding():
			r.rotate(Vector3(0,1,0),-rot)
		if rf.is_colliding() and rb.is_colliding():
			pass
		else:
			if rf.is_colliding():
			
		#		var xform = state.get_transform().rotated(Vector3(0,1,0),-rot)
		#		state.set_transform(xform)
				r.rotate(Vector3(0,1,0),rot)
			if rb.is_colliding():
				
				r.rotate(Vector3(0,-1,0),rot)
		#		var xform = state.get_transform().rotated(Vector3(0,1,0),rot)
		#		state.set_transform(xform)
		self.apply_impulse(Vector3(0, 0,0),forward)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bodies=get_colliding_bodies()
#	decel = range_lerp(spd,0,5,maxdecel,300)
	for body in bodies:
#		print(body.get_name())
		pass
#	print(clamp(range_lerp(ctimer,1,130,1,2),1,2))
	if(bodies):
#		print(bodies)
		for body in bodies:
			print(body.name)
			if body.name!="StaticBody":
				print("CONES")
				alive = false
				self.set_mode(0)
#				self.physics_material_override()
			
	rot = delta *1
	var v = clamp(range_lerp(self.linear_velocity.length(),1,100,1,0.1),3,1)*delta
	if(v<0.01): 
		v=0.01
	print(forward)
	forward = Basis(r.global_transform.basis).z*v
	
#	if rb.is_colliding():
#		self.add_torque(Vector3(0,10,0)*delta)
#	if rf.is_colliding():
#		self.add_torque(Vector3(0,-10,0)*delta)
	
#	print(self.rotation)
#	self.apply_impulse(Vector3(0, 0,0),Vector3(0,0,1)*delta*10000)
	pass
