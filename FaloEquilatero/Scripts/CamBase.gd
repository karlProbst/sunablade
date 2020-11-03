extends Spatial

onready var rotSpd = 0
var tiltSpd = 0

#HIS SOLUTION
var originalCamZoom = null
var originalCamVect = null
#HIS SOLUTION

var mouseSpeed = Vector2()

var camRay
var camera

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#HIS SOLUTION
	originalCamVect = Vector3(0,-20,0)
	originalCamZoom = 1
	#HIS SOLUTION
	camera = self
	camRay = camera.get_node("CamRay")
	

	camRay.add_exception(get_node(".."))

func _process(delta):

	var friction = 0.1

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
		if abs(camRot) > 0.1:
			rotSpd += camRot * 0.2

		camRot = -Input.get_joy_axis(0, 3)
		if abs(camRot) > 0.1:
			tiltSpd += camRot * 0.2

	
	var maxRotSpd = 2.5
	var maxTiltSpd = 0

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
	var root = get_tree().get_root().get_node("node/vc/v/beyblade")

	if get_parent().get_name() == "Player":  # Reparent
		get_parent().remove_child(self)
		root.add_child(self)
	

	var target = root
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
	
func _input(event):
	
	if event is InputEventMouseMotion:
		mouseSpeed = event.relative
	elif event is InputEventKey && event.pressed && event.scancode == KEY_F11:
		OS.set_window_maximized(not OS.is_window_maximized())
