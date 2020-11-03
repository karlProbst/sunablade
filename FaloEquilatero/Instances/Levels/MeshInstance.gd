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

onready var player = get_tree().get_current_scene().get_node("vc/v/beyblade")
onready var camera = player.get_node("CamBase")
onready var this = get_tree().get_current_scene().get_node("vc/v/DownVP")
onready var vc = get_tree().get_current_scene().get_node("vc/v/ViewportContainer")
func _process(delta):
#	this.rotation =  camera.rotation
	this.set_global_transform(Transform(Vector3(0,0,0),player.translation+Vector3(0,0,0)))
