extends Area
#
#var enemyPos = Vector3()
#var enemy
#
#func _ready():
#	connect("body_entered", self, "_on_body_enter")
#	connect("body_exited", self, "_on_body_exit")
#
#func _on_body_enter(body):
#	if body.is_in_group("Targetable"):
#		enemy = body;
#		enemyPos = body.get_transform().origin;
#		print("A Target has entered the Combat Area!")
#
#func _on_body_exit(body):
#	if body == enemy:
#		enemyPos = Vector3.ZERO
