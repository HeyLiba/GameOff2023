extends Node2D

func _input(event):
	if event.is_action("Jump"):
		Manager.next_level()
