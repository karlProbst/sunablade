extends Spatial

var myMat = null
var z1 = 0
var indo = true
func _ready():
	
	myMat = preload("Dust.material").duplicate()
	
	for node in get_children():
		var mat = node.set_surface_material(0, myMat)
	
	set_process(true)
	
func _process(delta):
	translation.y += 0.09+z1/11
	if indo:
		z1+=15*delta
		if z1>3:indo = false
		translation.x+=z1/5
	else:
		z1-=15*delta
		if z1<-3:indo = true
		translation.x-=z1/5
	scale = scale.normalized() * (scale.length() + .08)
	myMat.albedo_color.a -= 0.009
	if myMat.albedo_color.a <= 0.1:
		queue_free()
