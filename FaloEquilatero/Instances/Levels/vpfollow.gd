#extends Spatial
#
#onready var player = get_tree().get_current_scene().get_node("vc/v/beyblade")
#
#onready var this = get_tree().get_current_scene().get_node("vc/v/DownVp")
#onready var cm = get_tree().get_current_scene().get_node("vc/v/DownVp/CircularMesh")
#var t = 0
#func _process(delta):
#
#	var a = player.get_global_transform()[3].y
#	var globe = range_lerp(a,1,100,0.5,0.35) 
##	this.rotation =  camera.rotation
#
#	print(a)
#	t+= delta
#
#	if t>10:
#		cm.scale = Vector3(2,globe,2)
#		t = 0
#	this.translation = player.translation+Vector3(0,2.11-1.37,0)
#
extends Spatial

onready var player = get_tree().get_current_scene().get_node("vc/v/beyblade")

onready var this = get_tree().get_current_scene().get_node("vc/v/DownVp")
onready var ray = get_tree().get_current_scene().get_node("vc/v/DownVp/RayCast")
onready var bol = get_tree().get_current_scene().get_node("vc/v/DownVp/bolinha")
onready var cm = get_tree().get_current_scene().get_node("vc/v/DownVp/CircularMesh")
onready var cubo = get_tree().get_current_scene().get_node("vc/v/DownVp/cubo")
onready var scene = get_tree().get_current_scene().get_node("vc/v/")
var distance = 0
var t = 0
var x1 = -1
	
	
func _process(delta):
	if ray.is_colliding():
		var origin = ray.global_transform.origin
		var collision_point = ray.get_collision_point()
		distance = origin.distance_to(collision_point)
	ray.add_exception(player)
	cubo.scale.y = distance+5
	cubo.translation.y = -5
	var x0=distance
	if(distance>20):
		x0 = 20
	cubo.rotation.y+=delta*3		
	if(x1<0):
		cubo.scale.x =range_lerp(x1,-1,0,0,0.2)
		cubo.scale.z = range_lerp(x1,-1,0,0,0.2)
		x1=delta*0.05
	if(x1>0):
		x1= range_lerp(x0,0,20,0.2,0.05)+rand_range(0.01,0.01)
		cubo.scale.x = x1
		cubo.scale.z = x1
	this.translation = player.translation+Vector3(0,2.11-1.37,0)

	bol.translation = Vector3(0,distance,0)
	var x2= distance/4
	bol.scale = Vector3(x2,x2,x2)
#	if(bol.translation.y<1):
#		bol.translation.y = 1
	
func spawnDust():
#
#
#
	var dustScene = preload("res://Instances/Objects/bolinha.tscn")
	var dust = dustScene.instance()
	scene.add_child(dust)
	dust.translation = Vector3(player.translation.x,player.translation.y-distance,player.translation.z)
#	dust.vel = player.c
	#transform.basis.scale(scaling);
	
