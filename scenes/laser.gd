extends RayCast2D

func _physics_process(delta):
	if is_colliding():
		$Line2D.set_point_position(1,$Line2D.to_local(get_collision_point()))
		if get_collider().name == "Player":
			Manager.restart_level()
