
extends RigidBody
onready var player = get_tree().get_current_scene().get_node("Player")
var max_speed = 30
export (PackedScene) var cannon_ball=null
var spd =2
var can_shoot = true
onready var cambase= get_tree().get_current_scene().get_node("vc/v/beyblade/CamBase")
onready var camera= get_tree().get_current_scene().get_node("vc/v/beyblade/CamBase/Camera")
onready var this = get_tree().get_current_scene().get_node("vc/v/beyblade")
onready var bey = get_tree().get_current_scene().get_node("vc/v/beyblade/bey")
onready var beyC = get_tree().get_current_scene().get_node("vc/v/beyblade/bey/beyC")
onready var eye = get_tree().get_current_scene().get_node("vc/v/beyblade/eye")
onready var joy = get_tree().get_current_scene().get_node("vc/v/beyblade/joy")
onready var v = get_tree().get_current_scene().get_node("vc/v/")
onready var level = get_tree().get_current_scene()
var l 
var ctimer = 0
var beggining = true
var init0 = 5
var mouse_is_down = false
var down_position = Vector2(0.0, 0.0)
var shoot_strength = 0.2
var forward
var side
var grav = 0
var ground = false
var cair = -20
var v_size = Vector2(600,300)
var t =0
var t0 =0
var won=false
var xzvel = 0
var decel = 15
func _ready():
	

	this.set_mode(2)
	this.apply_impulse(Vector3(0, 0,0),Vector3(0,spd*300,0))
func _process(delta):
	if(!beggining and !won):
		camera.fov=90+(xzvel.length()*0.8)
	if(camera.fov>130 and !won):
		camera.fov=130
	
	xzvel =Vector3(linear_velocity.z,linear_velocity.x,linear_velocity.y/2)
	if(spd<1):
		spd=1
	

	if(linear_velocity.length()<6 and cair!=200):
		cair += delta
	elif(cair!=200 and cair>=0):
		cair = 0
	if(cair>2 and cair < 200 and init0<-5):
		var v = linear_velocity
		this.set_mode(0)
		this.apply_impulse(Vector3(0, 10,0),Vector3(v))
		cair = 200
	if(this.mode == 2):
	
		beyC.rotate(Vector3(0, 1, 0), xzvel.length()/3*delta)
	if(beggining):
		beyC.rotate(Vector3(0, 1, 0), -xzvel.length()/3*delta)
	forward = Basis(get_viewport().get_camera().global_transform.basis).z
	side = Basis(get_viewport().get_camera().global_transform.basis).x
	if(ground && grav<20):
		grav+=1*delta
	
	eye.set_global_transform(Transform(Vector3(0,0,0),Vector3(this.translation.x-(linear_velocity.x/20),this.translation.y+10,this.translation.z-(linear_velocity.z/20))))
	if(init0<-5 and !won):
		bey.look_at(Vector3(0,1,0),eye.translation)
	
	var bodies=get_colliding_bodies()
	
	spd = lerp(spd,xzvel.length()/decel,delta*0.2)
	if(bodies):
		init0-=1
	print(camera.fov)
	if(bodies and xzvel.length()>30 and ctimer<=0 ):
		v.set_hdr(false)
		v.set_hdr(true)
		ctimer=10
	
	if(ctimer>0):
		ctimer-=delta*10

	
	if(init0==4):
		v.set_size(Vector2(300,150))	
	if(init0==3):
		v.set_size(Vector2(200,100))	
	if(init0==2):
		v.set_size(Vector2(150,75))	
	if(init0==5 and v_size.length()>312):
		t += delta *0.1
	
		v.set_size(v_size)
		v.set_hdr(false)
		t0+= delta* 5
		
		v_size=lerp(Vector2(1200,300),Vector2(600,50),t)
		
	else:
		t = 0
	if(init0==4):
		
		beggining = false
	if(init0==3):
		pass
			
	if(!beggining ):
		t0+= delta* 5
		v.set_size(v_size)	
		t += delta *2
#		print(v_size)
#		print(init0)
		v_size=lerp(Vector2(600,250),Vector2(600,300),delta)
			
#	if(v.get_size().length()<315 and !init0):
#		t += delta * 0.001
#
#		v.set_size(v_size)
#		v_size=lerp(Vector2(305.4,7.8),Vector2(400,8),t*10)
#	elif !init0:
#
#		v.set_size(Vector2(500,50))
#		beggining=false
	print(xzvel.z)
	if(xzvel.z<-33 and !beggining):
		won=true
	if(won):
		beyC.rotation_degrees.z=lerp(beyC.rotation_degrees.z,180,delta)
		camera.fov = lerp(camera.fov,500,delta*0.1)
		linear_velocity.y-=1*delta
		cambase.rotSpd+=2
	if(!beggining):

		
		if(xzvel.length()>25 and xzvel.length()<40 ):
			v.set_debug_draw(false)
		if(xzvel.length()<3 and init0<-4):
			v.set_debug_draw(2)
		if(xzvel.length()>40):
			v.set_debug_draw(1)
##	var bodies = this.get_overlapping_bodies()
#	if bodies.has(this):
#		ground =false
#	else:
#		ground = true
#	var b = Basis(get_viewport().get_camera().global_transform.basis)
#	b.z.y = 0 # Crush Y so movement doesn't go into ground
#	b.z = b.z.normalized()
#	mv = b.xform(mv)
	l = linear_velocity
	
	if Input.is_action_pressed("1"):
		mode = RigidBody.MODE_RIGID
	if Input.is_action_pressed("2"):
		mode = RigidBody.MODE_CHARACTER
	if Input.is_action_pressed("3"):
		mode = RigidBody.MODE_STATIC
	if Input.is_action_pressed("4"):
		mode = RigidBody.MODE_KINEMATIC
		
	if Input.is_action_pressed("q"):
		cambase.rotSpd+=1
	if Input.is_action_pressed("e"):
		cambase.rotSpd -=1
	if(this.mode == 2 and !beggining):		

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
			
func _input(event):
	pass
func _integrate_forces(state):
	var xform = state.get_transform()
#	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
##		var new_speed = get_linear_velocity().normalized()
##		new_speed *= max_speed
#		set_linear_velocity(clamp(get_linear_velocity().y, maxspeed, -maxspeed)
##		set_linear_velocity(new_speed)
##		state.set_transform(xform)
##
#
	
	if(linear_velocity.y<=0 and init0==5):
		xform.origin.y = 28
		state.set_transform(xform)
		v.set_size(Vector2(30,15))	
		init0-=1
	
			
