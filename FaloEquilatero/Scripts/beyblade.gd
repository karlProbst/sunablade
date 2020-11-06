
extends RigidBody

var maxspd = 5
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
onready var vp = get_tree().get_current_scene().get_node("vc/v/")
onready var vc = get_tree().get_current_scene().get_node("vc")
onready var we = get_tree().get_current_scene().get_node("vc/v/WorldEnvironment")
onready var art = get_tree().get_current_scene().get_node("vc/v/artifact0")
onready var ShaderB = preload("res://inversetrip.shader")
onready var ShaderG = preload("res://neutraltrip.shader")
onready var ShaderN = preload("res://neutraltrip.shader")
var level = 0
var maxdecel = 20
var lock =0
var l 
var ctimer = 0
var beggining = true
var init0 = 5
var charge_left =1
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
export var decel = 80
var won_y_lerp = 28
var v1 = Vector3(0,0,0)
var ssss= 0
var a
var c
var pos
var glow = 0.5
var teleport
var spdr
var cone = false
var d = 0.3
var bodies
func _ready():
	if(Global.level > 0):
		vc.material.shader = ShaderG
#		decel = 30
	if(Global.level == 0):
		vc.material.shader = ShaderN
#		decel =30
	if(Global.level < 0):
		vc.material.shader = ShaderB
		decel = range_lerp(Global.level,0,-5,10,2)
	this.set_mode(2)
	this.apply_impulse(Vector3(0, 0,0),Vector3(0,spd*300,0))
func _process(delta):
	if(ssss==0):
		a = this.get_global_transform()[3]
		ssss = 2
	ssss-=1 
	if(!beggining and !won):
		camera.fov=90+(xzvel.length()*0.8)
	if(camera.fov>130 and !won):
		camera.fov=130
#	print("c ",camera.fov, " v "," init0", init0, "b", beggining," won",won, "glow", glow)
	xzvel =Vector3(linear_velocity.z,linear_velocity.x,linear_velocity.y/2)
	if(spd<0.7):
		spd=0.7
	

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
	
		beyC.rotate(Vector3(0, 1, 0), spd*4*delta)
#	print(spd*1.5)
	if(beggining):
		beyC.rotate(Vector3(0, 1, 0), -xzvel.length()/3*delta)
		spd = 0
	forward = Basis(get_viewport().get_camera().global_transform.basis).z
	forward[1]=0
	side = Basis(get_viewport().get_camera().global_transform.basis).x
	if(ground && grav<20):
		grav+=1*delta
	
	eye.set_global_transform(Transform(Vector3(0,0,0),Vector3(this.translation.x-(linear_velocity.x/20),this.translation.y+10,this.translation.z-(linear_velocity.z/20))))
	if(!beggining and !won):
#		bey.look_at(Vector3(0,1,0),eye.translation)
		bey.rotation_degrees.z= clamp(range_lerp(xzvel.z,-30,30,-10,10),-10,10)
		bey.rotation_degrees.x= clamp(range_lerp(xzvel.x,-30,30,-10,10),-10,10)

	bodies=get_colliding_bodies()
#	decel = range_lerp(spd,0,5,maxdecel,300)
	for body in bodies:
#		print(body.get_name())
		pass
	spd = lerp(spd,xzvel.length()/decel,delta*0.05)
	spdr = spd * 1.2* clamp(range_lerp(ctimer,1,200,1,2),1,2)
#	print(clamp(range_lerp(ctimer,1,130,1,2),1,2))
	if(bodies):
#		print(bodies)
		for body in bodies:
			if body.is_in_group("cones"):
				print("CONES")
				cone = true
			else:
				cone = false
		if(init0>-5):
			init0-=1
		charge_left = 1
		ctimer = 0
	if(charge_left>=0.01):
		charge_left-=delta*0.01
	
	if(bodies and xzvel.length()>30 and ctimer>10 ):
		vp.set_hdr(false)
		vp.set_hdr(true)
		print(vp.get_hdr())
		ctimer = 0
#	print(we.get_auto_exposure_enabled())
	ctimer+=delta*10

	

	if(init0==5):
		camera.fov+=delta*3

		t += delta *20
		cambase.rotSpd+=2
		
		vp.set_hdr(false)
		t0+= delta* 0.5
		if(t0>1):
			vp.set_size(v_size)
#			v_size=lerp(Vector2(10,5),Vector2(600,300),t0)
			t0=0
		
	else:
		t = 0
	if(init0==4):
		if(Global.level<0):
			vp.set_size(Vector2(600/-Global.level,300/-Global.level))
		elif(Global.level>0):
			vp.set_size(Vector2(600/Global.level,300/Global.level))
		else:
			vp.set_size(Vector2(600,300))	
		
		cambase.tiltSpd = 15
		beggining = false

	
	if(!beggining ):
		t0+= delta* 5
	
		t += delta *2
#		print(v_size)
#		print(init0)
		
			
#	if(v.get_size().length()<315 and !init0):
#		t += delta * 0.001
#
#		v.set_size(v_size)
#		v_size=lerp(Vector2(305.4,7.8),Vector2(400,8),t*10)
#	elif !init0:
#
#		v.set_size(Vector2(500,50))
#		beggining=false
	
	if(get_global_transform()[3].y<-600 and !beggining and !won):
		Global.level -= 1
		vc.material.shader = ShaderB
		won=true	
	if(get_global_transform()[3].y>500 and !beggining and !won):
		Global.level += 1 
		vc.material.shader = ShaderG
		won=true
	if(!won):
#		print("pos0 = ",this.get_global_transform()[3])
		pass
	if a!=this.get_global_transform()[3] and !won:
		var b = this.get_global_transform()[3]
		for i in range(3):
			if(b[i]>=a[i]):
				a[i]= b[i]-a[i]
			else:
				a[i]= -(a[i]-b[i])
		c = a
		a[0] = stepify(a[0],0.1)
		a[1] = stepify(a[1],0.1)
		a[2] = stepify(a[2],0.1)
#		if abs(a[0]+a[2])>1:
#			vp.set_hdr(false)
#			vp.set_hdr(true)
#			ctimer=10
			
		
	

	#	X         X     000     N    N
	#	X         X    0   0    NN   N
	#	 X   X   X    0     0   N N  N
	#	  X X X X      0   0    N  N N
	#	   X   X        000     N   NN
	if(won):
		this.set_mode(4)
		glow+=delta*0.2
		we.environment.set_glow_strength(glow)
		
		if(lock == 0 and glow>1.4):
			if(glow>1.4):
				vp.set_debug_draw(2)
				teleport = true
				camera.fov=170
				art.reset = true
				glow = 0
			lock = -1
		if lock == -1 and camera.fov<60:
			get_tree().reload_current_scene()
			
		if(lock == 10):
			v1 =c
			lock = 1
#		this.set_mode(3)
#
#		if v1.length()>0.01 and lock == 1:
#			pos = this.get_global_transform()
#			this.set_global_transform(Transform(Vector3(0,0,0),Vector3(pos[3][0]+v1.x,pos[3][1]+v1.y,pos[3][2]+v1.z)))
#			v1 = v1.linear_interpolate(Vector3(0,0,0), delta*2)
#			print("pos1 = ",pos[3]," v1 = ",v1)
#		elif lock==1:
#			v1 = -c*2
#			lock = 2
#
#		if(lock == 2 and v1.length()>0.01):
#			pos = this.get_global_transform()
#			this.set_global_transform(Transform(Vector3(0,0,0),Vector3(pos[3][0]+v1.x,pos[3][1]+v1.y,pos[3][2]+v1.z)))
#			v1 = v1.linear_interpolate(Vector3(0,0,0), delta*2)
#			print("pos1 = ",pos[3]," v1 = ",v1)
#			if(v1.length()<0.01):
#				lock= 3
#
#		if(lock==3):
#
#			won_y_lerp += delta*100
#			beyC.rotation_degrees.z=lerp(beyC.rotation_degrees.z,180,delta)
#			vp.set_debug_draw(2)
#			this.set_global_transform(Transform(Vector3(0,0,0),Vector3(0,won_y_lerp,0)))
		
		camera.fov-=delta*20
		cambase.tiltSpd -= 1
		cambase.rotSpd+=2
	if(!beggining and !won):
		
		
		if(xzvel.length()>25 and xzvel.length()<40):
			if(Global.level>0):
#				vp.set_debug_draw(false)
#			else:
#				vp.set_debug_draw(2)
				pass
		if(xzvel.length()<10 and init0<2 and bodies):
			if(Global.level>0):
#				vp.set_debug_draw(2)
#			else:
#				vp.set_debug_draw(false)
				pass
		
		if(xzvel.length()>40):
			pass

	if(!won and init0<4):
		var dist_art = this.get_global_transform()[3].distance_to(art.get_global_transform()[3])
#		glow = range_lerp(dist_art, 10, 90, .3, .2)
#		we.environment.set_glow_strength(glow)
		var bb = range_lerp((abs(linear_velocity.y*2)+0.111/xzvel.length()+0.521), 1, 60, 0,15)
		bb = stepify(bb, 0.1)
		cambase.tiltSpd = -bb
		cambase.tiltSpd += delta
	d = delta
		
##	var bodies = this.get_overlapping_bodies()
#	if bodies.has(this):
#		ground =false
#	else:
#		ground = true
#	var b = Basis(get_viewport().get_camera().global_transform.basis)
#	b.z.y = 0 # Crush Y so movement doesn't go into ground
#	b.z = b.z.normalized()
#	mv = b.xform(mv)
#	print("spd = ",spd," spdr = ",spdr," forward = ",forward," side = ",side)

#	print(decel," spd = ",spd)
func look_follow(state, current_transform, target_position):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)

	state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))
	

func _integrate_forces(state):

	l = linear_velocity
	if(cone):
		this.set_gravity_scale(0.0)
	if Input.is_action_pressed("1"):
		if(beggining):
			
			this.apply_impulse(Vector3(0, 0,0),Vector3(0,-1,0)*300*d)
		this.apply_impulse(Vector3(0, 0,0),Vector3(0,-1,0)*30)
#		if(charge_left>0):
#			charge_left-=d
		
	if Input.is_action_pressed("2"):
		this.apply_impulse(Vector3(0, 0,0),Vector3(0,1,0)*charge_left*7*spd)
		if(charge_left>0):
			charge_left-=d
#		mode = RigidBody.MODE_CHARACTER
	if Input.is_action_pressed("3"):
		if(bodies):
			linear_velocity.y = 0
#		mode = RigidBody.MODE_STATIC
	if Input.is_action_pressed("4"):
		mode = RigidBody.MODE_KINEMATIC
		
	if Input.is_action_pressed("q"):
		cambase.rotSpd+=1
	if Input.is_action_pressed("e"):
		cambase.rotSpd -=1

	var xz = Vector3(this.linear_velocity.x,0,this.linear_velocity.z)
	if(this.mode == 2 and !beggining):		
	
		if Input.is_action_pressed("forward"):
#			print(-forward*maxspd*spd)
#			if(xz*forward>xz*forward*maxspd):
			this.apply_impulse(Vector3(0, 0,0),-forward*spdr)
#			else:
#				print("MAXSPED")
		if Input.is_action_pressed("back"):
#			if(xz<forward*spd*maxspd):
			this.apply_impulse(Vector3(0, 0,0),forward*spdr)
		if Input.is_action_pressed("right"):
#			joy.look_at(Vector3(0,1,0),Vector3(10,-20,0))
			
			this.apply_impulse(Vector3(0, 0,0),side*spdr)
		if Input.is_action_pressed("left"):
#			joy.look_at(Vector3(0,1,0),Vector3(-10,-20,0))
		
			this.apply_impulse(Vector3(0, 0,0),-side*spdr)
			
	if linear_velocity.y<=0 and init0==5 :
		if camera.fov<60:
			camera.fov = 60
		teleport = true
		init0-=1
	var xform = state.get_transform()
#	if abs(get_linear_velocity().x) > max_speed or abs(get_linear_velocity().y) > max_speed:
##		var new_speed = get_linear_velocity().normalized()
##		new_speed *= max_speed
#		set_linear_velocity(clamp(get_linear_velocity().y, maxspeed, -maxspeed)
##		set_linear_velocity(new_speed)
##		state.set_transform(xform)
	if(won):
		var target_position = Vector3(0,-1000,0)
		look_follow(state, get_global_transform(), target_position)
		
	if(teleport):
		xform.origin.y = 28*3
		state.set_transform(xform)
	
		print("TELEPORTA")
		teleport = false
			
func _on_body_enter(body):  # body is always passed as a parameter in this signal, check the Area2D documentation for 2.1    
	if body.is_in_group("level"):  
		print("Following!")  
	print("Following!")  
		
