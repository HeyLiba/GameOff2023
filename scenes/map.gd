@tool
extends Polygon2D

var last_points = 0

func _process(delta):
	if Engine.is_editor_hint():
		if polygon.size() != last_points:
			last_points = polygon.size()
			var polygonlist = polygon
			$StaticBody2D/CollisionPolygon2D.polygon = polygon
			var occluder = OccluderPolygon2D.new()
			occluder.polygon = Geometry2D.offset_polygon(polygonlist,-7)[0]
			$LightOccluder2D.occluder = occluder
			set_editable_instance(self,true)
			set_editable_instance($StaticBody2D,true)
			set_editable_instance($StaticBody2D/CollisionPolygon2D,true)
			set_editable_instance($LightOccluder2D,true)
