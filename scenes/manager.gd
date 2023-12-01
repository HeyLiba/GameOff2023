extends Node
signal restart
signal next

func restart_level():
	restart.emit()
	print("restart")

func next_level():
	next.emit()
	print("next")
