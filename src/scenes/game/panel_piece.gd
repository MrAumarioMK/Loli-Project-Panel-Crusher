class_name PanelPiece extends RigidBody2D


signal destroy_requested(panel_piece)


# *First 2022-12-21 ตัวแปรชั่วคราว ให้ย้ายไปเป็น global variable ถ้ามีระบบอื่น ๆ หลายตัวต้องใช้
enum Type {
	EARTH = 1,
	FIRE = 2,
	AQUA = 3,
	WIND = 4,
	HEART = 5,
}


const SPRITE_TYPE = {
	Type.EARTH: preload("res://assets/img/Earth Panels.png"),
	Type.FIRE: preload("res://assets/img/Fire Panels.png"),
	Type.AQUA: preload("res://assets/img/Aqua Panels.png"),
	Type.WIND: preload("res://assets/img/Wind Panels.png"),
	Type.HEART: preload("res://assets/img/Heart Panels.png"),
}


var type: Type:
	set(value):
		type = value
		update_appearance()

var piece_connections = PanelPieceConnections.new()

var highlight: bool:
	set(value):
		highlight = value
		update_appearance()

var is_tapping_over: bool


func update_appearance():
	$Sprite2D.texture = SPRITE_TYPE[type]
	$Sprite2D.modulate = Color.BLACK if is_tapping_over else Color.WHITE # *First 2022-12-26 เอฟเฟกต์ชั่วคราว


func is_just_pressed_or_dragging(event) -> bool:
	return ((event is InputEventScreenTouch and event.is_pressed())
		or event is InputEventScreenDrag)


func is_released(event) -> bool:
	return event is InputEventScreenTouch and not event.is_pressed()


func _on_tap_area_2d_input_event(viewport, event, shape_idx):
	if is_just_pressed_or_dragging(event):
		is_tapping_over = true
	if is_released(event):
		emit_signal("destroy_requested")


func _on_neighbor_pair_area_2d_area_entered(area):
	piece_connections.add_neighbor(area.owner, self)


func _on_neighbor_pair_area_2d_area_exited(area):
	piece_connections.remove_neighbor(area.owner)

