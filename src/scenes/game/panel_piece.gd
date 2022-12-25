class_name PanelPiece extends RigidBody2D

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


func update_appearance():
	$Sprite2D.texture = SPRITE_TYPE[type]


func _on_tap_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		print()
		print('From ', self.name)
		print('Adjacent pairs: ' , piece_connections.pairs.size())
		for panel_piece in piece_connections.pairs:
			print('-> ', panel_piece.type, ': ', panel_piece.name)
		
		var linked_pieces = piece_connections.get_linked_pieces(self)
		print('Linked pairs: ', linked_pieces.size())
		for panel_piece in linked_pieces:
			print('-> ', panel_piece)
			panel_piece.queue_free()


func _on_pair_area_2d_area_entered(area: Area2D):
	piece_connections.pair(area.owner, self)


func _on_pair_area_2d_area_exited(area):
	piece_connections.unpair(area.owner)
