extends Spatial

onready var player = get_tree().get_current_scene().get_node("vc/v/beyblade")

onready var this = get_tree().get_current_scene().get_node("vc/v/DownVp")
onready var cm = get_tree().get_current_scene().get_node("vc/v/DownVp/CircularMesh")

func _process(delta):
	
	var globe = range_lerp(abs(player.get_global_transform()[3].y),1,100,0.5,0.35) 
#	this.rotation =  camera.rotation
	cm.scale = Vector3(2,globe,2)
	
	print(cm.rotation)
	this.translation = player.translation+Vector3(0,42.11-41.37,0)
	
