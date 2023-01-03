class_name PanelPiece extends RigidBody2D


signal touch_hitbox_entered(panel_piece, touch_index)

signal touch_hitbox_exited(panel_piece, touch_index)

signal destroy_requested(panel_piece, touch_index)


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

var touch_hitboxes_in_area: Array[TouchHitbox]


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not event.is_pressed():
		if touch_hitboxes_in_area.size() > 0:
			emit_signal("destroy_requested", self, touch_hitboxes_in_area[0].touch_index)


func update_appearance():
	$Sprite2D.texture = SPRITE_TYPE[type]
	$Sprite2D.modulate = Color.BLACK if highlight else Color.WHITE # *First 2022-12-26 เอฟเฟกต์ชั่วคราว


func _on_neighbor_pair_area_2d_area_entered(area):
	if area.owner is PanelPiece:
		piece_connections.add_neighbor(area.owner, self)


func _on_neighbor_pair_area_2d_area_exited(area):
	if area.owner is PanelPiece:
		piece_connections.remove_neighbor(area.owner)


func _on_tap_area_2d_area_entered(area: Area2D) -> void:
	if area.owner is TouchHitbox:
		touch_hitboxes_in_area.append(area.owner)
		emit_signal("touch_hitbox_entered", self, area.owner.touch_index)


func _on_tap_area_2d_area_exited(area: Area2D) -> void:
	if area.owner is TouchHitbox:
		touch_hitboxes_in_area.erase(area.owner)
		emit_signal("touch_hitbox_exited", self, area.owner.touch_index)
