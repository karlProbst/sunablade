extends ViewportContainer
onready var vp = get_tree().get_current_scene().get_node("v")
func _unhandled_input(event):
	vp.unhandled_input(event)
