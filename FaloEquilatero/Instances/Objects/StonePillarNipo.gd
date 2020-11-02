extends KinematicBody

enum State {
	ACTIVE,
	HANGING
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var facing = Vector3(0, 0, -1)

var moveVec = Vector3()
var tiltVec = Vector3()
var analogVec = Vector3()

var airAccelRate = 0.25
var maxSpd = 3
var friction = 2
var accelRate = 2 + friction
var gravity = 1.2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	 rotate(Vector3(0, 1, 0), PI*delta)

	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
