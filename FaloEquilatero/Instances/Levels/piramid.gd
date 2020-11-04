extends RigidBody

var a 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var reset= true

onready var player = get_tree().get_current_scene().get_node("vc/v/beyblade")
onready var this = get_tree().get_current_scene().get_node("vc/v/artifact0")
onready var p = get_tree().get_current_scene().get_node("vc/v/artifact0/PORTAL")
onready var p2 = get_tree().get_current_scene().get_node("vc/v/artifact0/PORTAL2")
func _process(delta):
	if(reset):
		
		linear_velocity=Vector3(0,0,0)
		this.translation=Vector3(0, 37, 0)
		p.scale = Vector3(1,1,1)
		reset = false
	rotate(Vector3(0, 1, 0), 2*delta)
	var bodies=get_colliding_bodies()
	
	if(bodies and !a):
		player.won=true
		Global.level += 1
		a = true
	if a:
		p.scale = lerp(p.scale,Vector3(50,50,50),delta*0.005)
		p2.scale = lerp(p2.scale,Vector3(50,50,50),delta*0.005)
		this.translation=lerp(this.translation,player.translation,delta)
		player.translation=lerp(player.translation,this.translation,delta)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
