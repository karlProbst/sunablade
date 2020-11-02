extends Spatial

func spawnDust():
	
	var dustScene = preload("res://Instances/Objects/dust/Dust.tscn")
	var dust = dustScene.instance()
	get_viewport().get_child(0).add_child(dust)
	dust.translation = get_parent().translation
