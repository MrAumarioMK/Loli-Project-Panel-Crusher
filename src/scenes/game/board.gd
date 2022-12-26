extends Node2D


const PANEL_PIECE = preload("res://src/scenes/game/panel_piece.tscn")


@export var max_panel_pieces: int = 50


var touch_input_count: int # *First 2022-12-26 ชั่วคราว เดี๋ยวค่อยสร้างตัวคุมแยกเป็น reusable touch handler


func _ready():
	for i in max_panel_pieces: # *First 2022-12-26 collision ทุกตัวแย่งที่อยู่กัน ทำให้มี spawn ออกนอก board ไว้ค่อยมาแก้
		spawn_panel_piece()


func _input(event):
	if event is InputEventScreenTouch:
		touch_input_count += 1 if event.is_pressed() else -1
		
		if touch_input_count == 0:
			reset_panel_piece_highlights()


func spawn_panel_piece():
	if get_panel_pieces_count() > max_panel_pieces:
		return
	
	var pp = spawn_random_panel_piece()
	pp.global_position = get_random_spawn_position()
	pp.rotation = randf_range(0, 2 * PI)


func spawn_random_panel_piece():
	var pp = PANEL_PIECE.instantiate()
	%PanelPieces.add_child(pp)
	pp.type = randi_range(1, 5)
	pp.destroy_requested.connect(
		_on_panel_piece_destroy_requested.bind(pp)
	)
	pp.highlighting.connect(
		_on_panel_piece_highlighting.bind(pp)
	)
	return pp


func destroy_panel_piece(panel_piece: PanelPiece):
	var linked_pieces = panel_piece.piece_connections.get_linked_pieces(panel_piece)
	for pp in linked_pieces:
		pp.queue_free()


func get_random_spawn_position() -> Vector2:
	var p1 = %SpawnLine.get_point_position(0)
	var p2 = %SpawnLine.get_point_position(1)
	var pos = p1.lerp(p2, randf())
	
	return pos


func get_panel_pieces_count() -> int:
	return %PanelPieces.get_child_count()


func highlight_linked_panel_pieces(panel_piece: PanelPiece):
	# Highlight preparation
	reset_panel_piece_highlights()
	
	var linked_pieces = panel_piece.piece_connections.get_linked_pieces(panel_piece)
	for pp in linked_pieces:
		pp.highlight = true


func reset_panel_piece_highlights():
	for pp in %PanelPieces.get_children():
		pp.highlight = false


# Connected from creation of PanelPiece
func _on_panel_piece_destroy_requested(panel_piece: PanelPiece):
	destroy_panel_piece(panel_piece)


# Connected from creation of PanelPiece
func _on_panel_piece_highlighting(panel_piece: PanelPiece):
	highlight_linked_panel_pieces(panel_piece)


func _on_panel_pieces_child_exiting_tree(node):
	# Awake all children nodes of Rigidbody2D
	for panel_piece in %PanelPieces.get_children():
		if panel_piece == node: # ไม่ลูปกับโหนดที่กำลังถูกลบออกจาก tree
			continue
		
		if panel_piece is RigidBody2D:
			panel_piece.sleeping = false
	
	spawn_panel_piece()


func _on_touch_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		# TODO ถ้าหากจำเป็นต้องบังคับให้แตะใน touch area ก่อน ควรมีตัวแปร
		# can_highlight เซ็ตเป็น true บวกกับจำนวน touch ทั้งหมด
		# แล้วจึงกลับมาเป็น false (ตัวนับ touch อาจจะต้องมีตัวควบคุมแยก)
		pass
