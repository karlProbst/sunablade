extends KinematicBody

var currentAnim = null
var facing = Vector3(0, 0, -1)

var airAccelRate = 2
var maxSpd = 7

var moveVec = Vector3()
var tiltVec = Vector3()
var analogVec = Vector3()
var ledgeAccel = 0
var friction = 1
var accelRate = 0.5+ friction
var gravity = 0.6
#QUASE ENUM MAS N É PQ PREGUIÇA
var state = "IDLE"
var jumpSpd = 6
#time of the jump
const fullJump= 36
#if != 0 is jumping
var grabLedge = false
var varJump = 0
var grabLock = false
var wall_jumps = 0
var tripleJump = 0
var airTime = 10
var max_wall_jumps = 1
var jumpLock = false
var jump
var coyoteJump = null
var wasOnFloor = false
var grab = false
var grabStop = true
var grabLedgeSnapUp = false
var lame = 0
onready var anim = $ArmatureNGraphics/AnimationPlayer
onready var upperBlock = $Upper_Front_Ray/Cube
onready var midBlock = $Front_Ray/Cube
onready var ground_ray = get_node("Ground_Ray")
onready var front_ray = get_node("Front_Ray")
onready var upper_front_ray = get_node("Upper_Front_Ray")
onready var up_ray = get_node("ArmatureNGraphics/Up_Ray")
onready var down_ray = get_node("ArmatureNGraphics/Down_Ray")
onready var left_ray = get_node("ArmatureNGraphics/Left_Ray")
onready var right_ray = get_node("ArmatureNGraphics/Right_Ray")
onready var	hp_bar = get_node("../Control/HBoxContainer/VBoxContainer/Life")
onready var collision_shape = get_node("CollisionShape")

var targetAnim = null
func _ready():
	hp_bar.value = 10
	front_ray.add_exception(get_node("./"))
	anim.get_animation("Running").set_loop(true)
	coyoteJump = get_node("CoyoteJump")
func spawnDust():		# Spawn dust function
	$DustSpawner.spawnDust()
func _physics_process(delta):
#	change color based on colision
#	if upper_front_ray.is_colliding():
#		upperBlock.get_surface_material(0).albedo_color = Color(100,0,0)
#	else:
#		upperBlock.get_surface_material(0).albedo_color = Color(0,0,0)
#	if front_ray.is_colliding():
#		midBlock.get_surface_material(0).albedo_color = Color(100,0,0)
#	else:
#		midBlock.get_surface_material(0).albedo_color = Color(0,0,0)
		
	
	var grounded = is_on_floor()
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

	#DIreção
	var mv = Vector3()
	#Viradinha
	var tiltMagnitude = 0
	
	
	
	#INPUT
	if Input.is_action_pressed("move_r"):
		mv.x -= 1
	if Input.is_action_pressed("move_l"):
		mv.x += 1
		
	if Input.is_action_pressed("move_fw"):
		mv.z += 1
	if Input.is_action_pressed("move_bw"):
		mv.z -= 1
	
		
	#O tanto q vc aumenta o vector da direção é o quanto ele da a viradinha
	tiltMagnitude = mv.length()
		
	#SENSITIVE CONTROLLER INPUT
	if Input.get_joy_name(0) != null and mv.length() == 0:
		
		mv.x = -Input.get_joy_axis(0, 0)
		mv.z = -Input.get_joy_axis(0, 1)
		
		#O tanto q vc aumenta o vector da direção é o quanto ele da a viradinha
		tiltMagnitude = mv.length()
		
		#Acho que é uma dead zone. Ainda tenho que experimentar sem isso
		if tiltMagnitude <= 0.3:
			
			mv.x = 0
			mv.z = 0
		
		
	mv = mv.normalized()

	#Pega direção da camera
	var b = Basis(get_viewport().get_camera().global_transform.basis)
	b.z.y = 0 # Crush Y so movement doesn't go into ground
	b.z = b.z.normalized()
	mv = b.xform(mv)
	
	mv.z *= -1
	mv.x *= -1
	
#	AFUNDAR NA TERRA
	collision_shape.transform.origin = Vector3(0,0.6+lame,0)
	
#	fundo maximo
	if lame>0.7:
		lame = 0.7
		
	if tiltMagnitude >= 0.3 and !grab:
#		pauzoes de grab
		front_ray.look_at(translation- mv,Vector3(0,-1,0) )
		front_ray.rotation_degrees.x=90
		upper_front_ray.look_at(translation- mv,Vector3(0,-1,0) )
		upper_front_ray.rotation_degrees.x=90
	
	if mv.length() > 0:
		analogVec = mv
	if is_on_floor():
		airTime = 0
		if mv.length() > 0.5:
			targetAnim = "Running"
		else:
			targetAnim = "Idle"	
	else:
		if(!grab):
			airTime += 10*delta
		else:				
#			collision_shape.transform.origin = Vector3(0,0,0)
			airTime = 0
		if(grab and (targetAnim=="Jumping From Wall" || targetAnim=="Jump From Wall") ):
			targetAnim = "Hanging Idle"
		if Input.is_action_just_pressed("jump") and targetAnim == "Hanging Idle" and !grabLock:
			targetAnim = "Jumping From Wall"
		
		if(targetAnim != "Jumping From Wall" || targetAnim=="Jump From Wall"):
			if(varJump> 0 and varJump < fullJump/1.7 and !grab):
				targetAnim = "Jumping"
			elif(grab):
				targetAnim = "Hanging Idle"
			elif(airTime>1):
				targetAnim = "Jump"
			else:
				targetAnim = "Running"
	
#	vira pra onde anda,mude o * para mexer na velocidade de girar
	if(grab):
		facing = -front_ray.get_collision_normal()
		analogVec = -front_ray.get_collision_normal()
	elif(targetAnim=="Jumping From Wall"):
		pass
	elif(varJump>0 and varJump<fullJump/2):
		facing += (analogVec.normalized() - facing) * 2 * delta
	elif airTime>1:
		facing += (analogVec.normalized() - facing) * 25 * delta
	else:
		facing += (analogVec.normalized() - facing) * 15 * delta
	facing = facing.normalized()
	facing.y = 0
	get_node("ArmatureNGraphics").look_at(translation - facing, Vector3(0, 1, 0) + (tiltVec * 0.25))


	#MOVIMENTO
	if is_on_floor():
		var mt = Vector3(moveVec.x, moveVec.y, moveVec.z)
		mt.y = 0
		if mt.length() > friction:
			var frict = moveVec.normalized() * friction
			frict.y = 0
			moveVec -= frict
		else:
			moveVec.x = 0
			moveVec.z = 0

		if mv.length() > 0:
			moveVec += mv * accelRate
	elif mv.length() > 0:
			moveVec += mv * airAccelRate
	
	#Gravidade
	var yspd = moveVec.y
	if(grounded):
		moveVec.y = 0
	

	var mSpd = maxSpd
	if is_on_floor():
		mSpd *= tiltMagnitude
	if moveVec.length() > mSpd:
		moveVec = moveVec.normalized() * mSpd

	#Gravidade 

#	GRAB
#	exits grab 

	
	
	var grabLedgeSnapLock = true
	if(airTime>=2 and (!upper_front_ray.is_colliding() or Input.is_action_pressed("grab2") ) and front_ray.is_colliding() and (varJump == 0 or varJump>15)):
		if(varJump>fullJump/4):
			jump = false
			varJump = 0
		grab = true
		grabLedge = true
		grabLedgeSnapLock = false
	if !Input.is_action_pressed("grab") and !grabLedge:
		grab = false
		grabLock = false
	if Input.is_action_just_released("grab"):
		grab = false
		grabLock = false
#	grabLock logic for jumping while grabbed
	if front_ray.is_colliding() and Input.is_action_pressed("grab") and !grabLock:
		grab = true
		
	
#	grabbed state freezes movement
	if(grab):
		lame = 0
		moveVec = Vector3(0,0,0)
		grabStop = false
#		exits grab and jump
		if Input.is_action_just_pressed("jump"):
			grabLock = true
			grab = false
	if(!grab):
		moveVec.y = yspd - gravity
		grabStop = true
	if(airTime>5 and grabLock and Input.is_action_pressed("grab")):
		grabLock = false
	
	if(grabLedge):
#		moveVec = move_and_slide(moveVec, facing)
		if !grabLedgeSnapLock:
			if up_ray.is_colliding():
				grabLedgeSnapUp = false
			else:
				grabLedgeSnapUp = true
			grabLedgeSnapLock = true
		get_node(".").translation+=facing*delta*3
		if(grabLedgeSnapUp and !up_ray.is_colliding()):
			move_and_slide(Vector3(0,-1.4,0), Vector3(0, 1, 0))	
		if(!grabLedgeSnapUp and up_ray.is_colliding()):
			move_and_slide(Vector3(0,1.4,0), Vector3(0, 1, 0))	
	
	if is_on_floor() || grab:
		coyoteJump.start()
#		letGoPosition = translation
		if not wasOnFloor and !grab:
			spawnDust()
	
#JUMP	
#Logica de jumplock para evitar pulo continuo Se segurar espaço 
	if(grounded):
		wall_jumps = max_wall_jumps
	if Input.is_action_pressed("jump") and (ground_ray.is_colliding() or grounded or coyoteJump.get_time_left() > 0 or is_on_wall() ) and !jumpLock:
		if is_on_wall():
			wall_jumps-=1
		if lame>0:
			lame-=0.04
			jumpLock = true
		else:
			jump = true
			grabLedge = false
	else:
		jump = false
	if !Input.is_action_pressed("jump") and (ground_ray.is_colliding() or grounded or coyoteJump.get_time_left() > 0 or is_on_wall() ):
		jumpLock = false
#	jump until varjump reaches 20 OR player releases jump
	if(varJump != 0 and Input.is_action_pressed("jump") and varJump < fullJump and !grab):
		varJump += 1
	

		if varJump<fullJump/1.5:
			moveVec.y = jumpSpd
		elif varJump<fullJump/3:
			moveVec.y = jumpSpd/3
		else:
			moveVec.y = jumpSpd/6
	if !Input.is_action_pressed("jump") or is_on_ceiling():
		varJump = 0
# jumpar
	if varJump == 0 and jump and (ground_ray.is_colliding() or grounded or coyoteJump.get_time_left() > 0 or is_on_wall() ):
		moveVec.y = jumpSpd
		varJump = 1
		coyoteJump.stop()
		jumpLock = true	

	wasOnFloor = is_on_floor()
	
	var prevPos = translation

	#Faz ele simexer
#	moveVec = move_and_slide(moveVec, Vector3(0, 1, 0),false,4,0.6)
	var step = 0.01
	
	moveVec = move_and_slide(Vector3(stepify(moveVec.x / (1+lame),step),stepify(moveVec.y / (1+lame),step),stepify(moveVec.z / (1+lame),step)), Vector3(0, 1, 0),false,4,0.6)
	
	
	#	"""""MAGICA"""""-dustzinho qnd aperta trigger
	if Input.is_action_pressed("grab2"):
		spawnDust()
#	animation
	if not anim.is_playing() or currentAnim != targetAnim:
		if targetAnim == "Run":
			$DustAnimation.play("Run")
			
		else:
			$DustAnimation.stop()
		if(targetAnim == "Jumping From Wall"):
			anim.play(targetAnim, 0)
		else:
			anim.play(targetAnim, 0.15)
		currentAnim = targetAnim
#  note: add cumChamber
	if(state == "MOVING"):
		if(moveVec.length()>=maxSpd/1.1):
			spawnDust()
		anim.playback_speed = stepify(tiltMagnitude/(1+lame*2),0.01)*1.7;
		$DustAnimation.playback_speed = stepify(tiltMagnitude,0.01)*1.7;
	else:
		anim.playback_speed = 1
		
	var t = moveVec.normalized()
	if moveVec.length() > 0.01:
		tiltVec += (moveVec.normalized() - tiltVec) * 1
	else:
		tiltVec.x -= tiltVec.x * .5
		tiltVec.y -= tiltVec.y * .5
		tiltVec.z -= tiltVec.z * .5
#STATE CHOOSER
	if(airTime<1):
		if stepify(moveVec.x, 0.1) == 0 and stepify(moveVec.z, 0.1) == 0:
			state = "IDLE"
		else:
			state = "MOVING"
	elif (!grab):
		state = "JUMPING"   
	else:
		state = "GRAB"                                                                                   
	
func mirror_vel():
	
	
	pass
