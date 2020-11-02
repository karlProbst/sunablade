extends KinematicBody

enum {
	FREE_CAM,
	LOCK
}

var state = FREE_CAM

const MOVE_SPEED = 15
const JUMP_FORCE = 20
const GRAVITY = 0.98
const MAX_FALL_SPEED = 11

const H_LOOK_SENS = 1
const V_LOOK_SENS = 1

onready var stateLabel = $StatePanel/StateName
onready var camBase = $CamBase
onready var camRay = $CamBase/CamRay
onready var actualCamera = $CamBase/Camera
onready var bunec = $MonotoriTestBuneco
onready var anim = $MonotoriTestBuneco/AnimationPlayer
onready var tgtRange = $TargetRange

var moveSpeed = MOVE_SPEED
var y_velo = 0

var initialCamPos

func _ready():
	anim.get_animation("run").set_loop(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	initialCamPos = actualCamera.translation
	
func _input(event):

	match state:
		FREE_CAM:
			stateLabel.text = "Free Cam"
			
			if event is InputEventMouseMotion:
				camBase.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
				camBase.rotation_degrees.x = clamp(camBase.rotation_degrees.x, -90, 0)
				#rotation_degrees.y -= event.relative.x * H_LOOK_SENS
				camBase.rotation_degrees.y -= event.relative.x * H_LOOK_SENS
				
		LOCK:
			stateLabel.text = "Lock"
			
			if Input.is_action_just_released("Lock"):
				state = FREE_CAM
			
func _physics_process(delta):
	
	if camRay.is_colliding():
		actualCamera.global_transform[3].x = camRay.get_collision_point().x
		actualCamera.global_transform[3].z = camRay.get_collision_point().z
		actualCamera.global_transform[3].y = camRay.get_collision_point().y
	else:
		actualCamera.translation = initialCamPos
	
	var move_vec = Vector3()
	if Input.is_action_pressed("move_fw"):
		move_vec.z -= 1
		bunec.rotation_degrees.y = camBase.rotation_degrees.y - 180
	if Input.is_action_pressed("move_bw"):
		move_vec.z += 1
		bunec.rotation_degrees.y = camBase.rotation_degrees.y - 180
	if Input.is_action_pressed("move_r"):
		move_vec.x += 1
		bunec.rotation_degrees.y = camBase.rotation_degrees.y - 180
	if Input.is_action_pressed("move_l"):
		move_vec.x -= 1
		bunec.rotation_degrees.y = camBase.rotation_degrees.y - 180
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), camBase.rotation.y)
	move_vec *= moveSpeed
			
	move_vec.y = y_velo
	move_and_slide(move_vec, Vector3(0,1,0))
	
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	var just_jumped = false
	if grounded and Input.is_action_just_pressed("jump"):
		just_jumped = true
		y_velo = JUMP_FORCE
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
	
	match state:
		FREE_CAM:	
			
			moveSpeed = MOVE_SPEED
			
			if just_jumped:
				play_anim("jump")
				if Input.is_action_pressed("move_bw"):
					print("mortalpratraz")
				elif Input.is_action_pressed("move_l"):
					print("mortalpraesquerda")
				elif Input.is_action_pressed("move_r"):
					print("mortalpradireita")
				elif Input.is_action_pressed("move_fw"):
					print("mortalprafrente")
			elif grounded:
				if move_vec.x == 0 and move_vec.z == 0:
					play_anim("idle")
				else:
					play_anim("run")
		
			if Input.is_action_pressed("Lock"):
				state = LOCK

		LOCK:
			moveSpeed = 5
			
			if tgtRange.enemyPos != Vector3(0,0,0):
				
				camBase.look_at(tgtRange.enemyPos, Vector3.UP)

			else:
				bunec.rotation_degrees.y = camBase.rotation_degrees.y -180
				camBase.rotation_degrees.x = -20
			
func play_anim(name):
	if anim.current_animation == name:
		return
	anim.play(name)
