extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var this = get_tree().get_current_scene().get_node("vc/v/beyblade")
func _process(delta):
	rotate(Vector3(0, 1, 0), 2*delta)
	var bodies=get_colliding_bodies()
	

	if(bodies):
		this.won=true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
