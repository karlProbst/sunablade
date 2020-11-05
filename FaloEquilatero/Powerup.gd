extends RigidBody

var a 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var reset= true

onready var player = get_tree().get_current_scene().get_node("vc/v/beyblade")
onready var this = get_tree().get_current_scene().get_node("vc/v/Powerup1")
onready var p = this.get_node("mesh1")
onready var p2 = this.get_node("mesh2")
func _ready():
	self.set_mode(RigidBody.MODE_KINEMATIC)
func _on_body_enter(body):
	print (body.get_name())
   
	
func _process(delta):
	
	if(this.translation.y<15):
		var vel =linear_velocity
		this.set_mode(4)
		rotate(Vector3(0, 1, 0), 2*delta)
		this.translation.z= this.translation.y+delta
#	print(this.get_mode()," y",this.translation.y)
