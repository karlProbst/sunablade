extends Spatial

onready var player = get_tree().get_current_scene().get_node("vc/v/beyblade")

onready var this = get_tree().get_current_scene().get_node("vc/v/DownVp")

func _process(delta):
#	this.rotation =  camera.rotation
	this.translation =player.translation+Vector3(0,0,0)
