class_name TouchHitbox extends Node2D


var index: int

var active: bool


func update_active(set: bool = active):
	$Area2D.monitorable = set
	$Sprite2D.visible = set
	active = set


func update_position(input_event_pos: Vector2):
	if get_viewport().get_camera_2d() != null:
		var screen_size = get_viewport().get_visible_rect().size
		var cam_pos = get_viewport().get_camera_2d().get_screen_center_position() - screen_size * 0.5
		global_position = cam_pos + input_event_pos
	else:
		global_position = input_event_pos

