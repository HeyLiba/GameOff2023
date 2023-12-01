extends StaticBody2D

var _base_scale : Vector2
@export var buttons_to_open : int = 1
var _current_buttons : int = 0

func  _ready():
	_base_scale = scale

func open():
	_current_buttons+=1
	
	if _current_buttons >= buttons_to_open:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "scale", Vector2(_base_scale.x,0), .5)

func close():
	_current_buttons -=1
	if _current_buttons < buttons_to_open:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "scale", _base_scale, .5)
