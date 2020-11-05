extends Spatial

var myMat = null
var z1 = 0
var indo = true
onready var vel = Vector3(0,0,0)
func _ready():
	
	myMat = preload("bola.material").duplicate()
	
	for node in get_children():
		var mat = node.set_surface_material(0, myMat)
	
	set_process(true)
	
func _process(delta):
	
	var d = delta*5
	scale += Vector3(d,d,d)
	myMat.albedo_color.r -= delta*10
	if myMat.albedo_color.r <= -1:
		queue_free()
#	self.translation.x +=vel[1]
