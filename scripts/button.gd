extends Area2D

@export var doors : Array[StaticBody2D]


func _on_body_entered(body):
	if len(get_overlapping_bodies()) > 1:
		return
#	if body is RigidBody2D:
#		if body.mass < .5 : return
	
	$AnimationPlayer.play("Pushed")
	for door in doors:
		if is_instance_valid(door):
			door.open()


func _on_body_exited(body):
	if has_overlapping_bodies():
		return
#	if body is RigidBody2D:
#		if body.mass < .5 : return
	$AnimationPlayer.play_backwards("Pushed")
	for door in doors:
		if is_instance_valid(door):
			door.close()
