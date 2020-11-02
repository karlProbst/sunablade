
extends RigidBody
onready var player = get_tree().get_current_scene().get_node("Player")

export (PackedScene) var cannon_ball=null
var spd =2
var can_shoot = true
onready var this = get_tree().get_current_scene().get_node("v/beyblade")
onready var bey = get_tree().get_current_scene().get_node("v/beyblade/bey")
onready var beyC = get_tree().get_current_scene().get_node("v/beyblade/bey/beyC")
onready var eye = get_tree().get_current_scene().get_node("v/beyblade/eye")
onready var joy = get_tree().get_current_scene().get_node("v/beyblade/joy")
onready var level = get_tree().get_current_scene()

var mouse_is_down = false
var down_position = Vector2(0.0, 0.0)
var shoot_strength = 0.2
var forward
var side
var grav = 0
var ground = false
var cair = 0
func _ready():
	this.set_mode(2)
	this.apply_impulse(Vector3(0, 0,0),Vector3(spd*0,spd*0,spd*10))
func _process(delta):
	
	if(linear_velocity.length()<6 and cair!=200):
		cair += delta
	elif(cair!=200):
		cair = 0
	if(cair>2 and cair < 200):
		var v = linear_velocity
		this.set_mode(0)
		this.apply_impulse(Vector3(0, 0,0),Vector3(v))
		cair = 200
	if(this.mode == 2):
	
		beyC.rotate(Vector3(0, 1, 0), linear_velocity.z/2*delta)
		
	forward = Basis(get_viewport().get_camera().global_transform.basis).z
	side = Basis(get_viewport().get_camera().global_transform.basis).x
	if(ground && grav<20):
		grav+=1*delta
	
	eye.set_global_transform(Transform(Vector3(0,0,0),Vector3(this.translation.x-(linear_velocity.x/20),this.translation.y+10,this.translation.z-(linear_velocity.z/20))))
	bey.look_at(Vector3(0,1,0),eye.translation)
	
	
##	var bodies = this.get_overlapping_bodies()
#	if bodies.has(this):
#		ground =false
#	else:
#		ground = true
#	var b = Basis(get_viewport().get_camera().global_transform.basis)
#	b.z.y = 0 # Crush Y so movement doesn't go into ground
#	b.z = b.z.normalized()
#	mv = b.xform(mv)
func _input(event):
	print(1)
	if Input.is_action_pressed("1"):
		mode = RigidBody.MODE_RIGID
	if Input.is_action_pressed("2"):
		mode = RigidBody.MODE_CHARACTER
	if Input.is_action_pressed("3"):
		mode = RigidBody.MODE_STATIC
	if Input.is_action_pressed("4"):
		mode = RigidBody.MODE_KINEMATIC
			
	if(this.mode == 2):		
		print("ASAA")
		if Input.is_action_pressed("forward"):
			joy.look_at(Vector3(0,1,0),Vector3(0,-20,10))
			this.apply_impulse(Vector3(0, 0,0),-forward*spd)
		if Input.is_action_pressed("back"):
			joy.look_at(Vector3(0,1,0),Vector3(0,-20,-10))
			this.apply_impulse(Vector3(0, 0,0),forward*spd)
		if Input.is_action_pressed("right"):
			joy.look_at(Vector3(0,1,0),Vector3(10,-20,0))
			this.apply_impulse(Vector3(0, 0,0),side*spd)
		if Input.is_action_pressed("left"):
			joy.look_at(Vector3(0,1,0),Vector3(-10,-20,0))
			this.apply_impulse(Vector3(0, 0,0),-side*spd)
	
	
			
