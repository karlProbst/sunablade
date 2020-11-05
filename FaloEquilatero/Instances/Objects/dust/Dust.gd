extends Spatial

var myMat = null
var z1 = 0
var indo = true
var lock = true
func _ready():
	
	myMat = preload("Dust.material").duplicate()
	
	
	
	set_process(true)
	
func _process(delta):
	if(!lock):
		translation += Vector3(randi() %10 -5, randi() %10 -5, randi() %10 -5)/8
		lock = true
	translation.y += 0.015
	
	scale = scale.normalized() * (scale.length() + .005)
	myMat.albedo_color.r -= 0.8*delta
	if myMat.albedo_color.r <= 0:
		queue_free()
