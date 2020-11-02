extends KinematicBody

export var gravity = Vector3.DOWN * 10
export var speed = 10
export var rot_speed = 0.85

var velocity = Vector3.ZERO

enum State {
	ACTIVE,
	HANGING
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var bey = get_tree().get_root().get_node("node/oBey/Cylinder")
#onready var bey2 = get_node("Cylinder")

var facing = Vector3(0, 0, -1)

var moveVec = Vector3()
var tiltVec = Vector3()
var analogVec = Vector3()

var airAccelRate = 0.25
var maxSpd = 3
var friction = 0.1
var accelRate = 2 + friction
var rot = 0
var collision 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	rot += velocity.length()*delta/50
	
#	if(rot >= 0 && rot<0.051):
#		bey.rotate(Vector3(0, 1, 0), rot)
#	else:
#		bey.rotate(Vector3(0, 1, 0), 0.051)
	velocity = velocity.linear_interpolate(Vector3(0,velocity.y,0), delta)
	rot = lerp(rot,0,friction/5)
	velocity.y += -10 * delta
	get_input(delta)
#	velocity = move_and_slide(velocity, Vector3.UP, false, 400, 0.785398,true )
	var col = move_and_collide(velocity,true)
	var remaining_vel
	print("vel= ",velocity)
	print("col= ",col)
	if col:
		var normal = col.normal
		remaining_vel = col.remainder
		remaining_vel.bounce(normal)
		velocity = remaining_vel
		print("remainvel= ",velocity)
		print("col= ",col)

	var slide_count = get_slide_count()
	var col_check= collision
	if slide_count:
		collision = get_slide_collision(slide_count - 1)
		var collider = collision.collider
	if(col_check!=collision):
	
		if(rot>0):
			rot+=velocity.length()/3
		else:
			rot-=velocity.length()/3
	
func get_input(delta):
	
	if Input.is_action_pressed("forward"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("back"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("right"):
		rotate_y(-rot_speed * delta)
	if Input.is_action_pressed("left"):
		rotate_y(rot_speed * delta)
		

	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
