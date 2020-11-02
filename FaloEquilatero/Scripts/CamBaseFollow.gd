extends Spatial
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

enum State {
	ACTIVE,
	HANGING
}

var currentAnim = null
var facing = Vector3(0, 0, -1)

var moveVec = Vector3()
var tiltVec = Vector3()
var analogVec = Vector3()

var airAccelRate = 0.25
var maxSpd = 3
var friction = 2
var accelRate = 2 + friction
var gravity = 1.2
var jumpSpd = 26
var coyoteJump = null
var wasOnFloor = false
var state = State.ACTIVE
var hangingFrom = null
var letGoPosition = Vector3()
var zLook = 100

var rotSpd = 0
var tiltSpd = 0

#HIS SOLUTION
var originalCamZoom = null
var originalCamVect = null
#HIS SOLUTION

var mouseSpeed = Vector2()

var camRay
var camera
onready var player = get_tree().get_current_scene().get_node("v/beyblade")
onready var this = get_tree().get_current_scene().get_node("v/CamBase")
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#HIS SOLUTION
	originalCamVect = get_node("Camera").translation.normalized()
	originalCamZoom = get_node("Camera").translation.length()
	#HIS SOLUTION
	
	camRay = get_node("CamRay")
	camera = get_node("Camera")
	
	camRay.add_exception(get_node(".."))

func _process(delta):
	
	var friction = 0.01

	if abs(rotSpd) > friction:
		rotSpd -= sign(rotSpd) * friction
	else:
		rotSpd = 0

	if abs(tiltSpd) > friction:
		tiltSpd -= sign(tiltSpd) * friction
	else:
		tiltSpd = 0
	
	rotSpd -= mouseSpeed.x * .01
	tiltSpd -= mouseSpeed.y * .01
	
	if Input.get_joy_name(0) != null:
		var camRot = -Input.get_joy_axis(0, 2)
		if abs(camRot) > 0.5:
			rotSpd += camRot * 0.2

		camRot = -Input.get_joy_axis(0, 3)
		if abs(camRot) > 0.5:
			tiltSpd += camRot * 0.2

	
	var maxRotSpd = 2.5
	var maxTiltSpd = 2.5

	rotSpd = max(min(rotSpd, maxRotSpd), -maxRotSpd)
	tiltSpd = max(min(tiltSpd, maxTiltSpd), -maxTiltSpd)
	
	var e = rotation

	if e.x > 0.05 and tiltSpd > 0:
		tiltSpd = 0

	if e.x < -1 and tiltSpd < 0:
		tiltSpd = 0
	
	rotate_y(rotSpd * delta)
	
	var xLocal = transform.basis.x.normalized()

	rotate(xLocal, tiltSpd * delta)
	
	
	
	#His solution to camera clamp on walls
	#HIS SOLUTION
	var root = get_tree().get_root()
	var toplevel = root.get_child(0)

	if get_parent().get_name() == "Player":  # Reparent
		get_parent().remove_child(self)
		toplevel.add_child(self)

	var target = toplevel.get_node("Player")
	
	if target != null:
		var tt = target.translation
		tt.y += 1
		translation += (tt - translation) * 1
	
	camRay.cast_to = originalCamVect * originalCamZoom

	var dist = camera.translation.length()
	var distTarget = originalCamZoom
	
	if camRay.is_colliding():
		distTarget = (camRay.get_collision_point() - translation).length() - .5

	dist += (distTarget - dist) * 1

	camera.translation = originalCamVect.normalized() * dist

	mouseSpeed.x = 0
	mouseSpeed.y = 0
	#HIS SOLUTION
	var mv = Vector3()

	var diff = player.translation - translation

		
	look_at(Vector3(player.translation.x,
		player.translation.y,
		player.translation.z)
		,Vector3(0,1,0))
	print(diff)	
	print(player.get_transform().basis)
	this.set_global_transform(Transform(Vector3(0,0,0),player.translation+Vector3(1.5,0.2,1.5)))
func _input(event):
	
	if event is InputEventMouseMotion:
		mouseSpeed = event.relative
	elif event is InputEventKey && event.pressed && event.scancode == KEY_F11:
		OS.set_window_maximized(not OS.is_window_maximized())
