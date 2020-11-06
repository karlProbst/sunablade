extends RigidBody

var a 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var reset= true

onready var player = get_tree().get_current_scene().get_node("vc/v/DownVp")

#onready var p = this.get_node("mesh1")
#onready var p2 = this.get_node("mesh2")
func _ready():
	
#	self.set_mode(RigidBody.MODE_KINEMATIC)
	connect("body_entered", self, "destroy")
func _on_body_enter(body):
	print (body.get_name())
   
	
func _process(delta):
	
	var origin = self.translation
	var v = Vector3(player.translation.x,player.translation.y-player.distance,player.translation.z)
	var distance = origin.distance_to(v)
#	var bodies=get_colliding_bodies()
	print(distance)
##	decel = range_lerp(spd,0,5,maxdecel,300)
#	for body in bodies:
#		print(bodies)
##		print(body.get_name())
#		pass
##	print(clamp(range_lerp(ctimer,1,130,1,2),1,2))
#	if(bodies):
#		print(bodies)
#		self.set_sleeping(false)
#		for body in bodies:
#			if body.is_in_group("cones"):
#				print("CONES")
#
#			else:
#				pass
	
#	if(this.translation.y<15):
#		var vel =linear_velocity
#		this.set_mode(4)
#		rotate(Vector3(0, 1, 0), 2*delta)
#		this.translation.z= this.translation.y+delta
#	print(this.get_mode()," y",this.translation.y)


func power(area):
	print("BUCETAP+17811")
	pass # Replace with function body.
