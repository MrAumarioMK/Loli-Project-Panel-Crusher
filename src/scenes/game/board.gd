extends Node2D


const PANEL_PIECE = preload("res://src/scenes/game/panel_piece.tscn")


@export var max_panel_pieces: int = 50


func _ready():
	for i in max_panel_pieces: # *First 2022-12-26 collision ทุกตัวแย่งที่อยู่กัน ทำให้มี spawn ออกนอก board ไว้ค่อยมาแก้
		spawn_panel_piece()


func _input(event: InputEvent):
	# Check Touch released from inside BoardTouchArea2D
	if event is InputEventScreenTouch:
		if not event.is_pressed() and %BoardTouchArea2D.can_unregister_touch(event):
			%BoardTouchArea2D.unregister_touch()
	
	if is_dragging_over_area(event):
		_process_board_touch_highlighting()


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
	var linked_pieces = panel_piece.piece_connections.get_linked_pieces(panel_piece)
	for pp in linked_pieces:
		pp.highlight = true


func unhighlight_all_panel_pieces():
	for pp in %PanelPieces.get_children():
		pp.highlight = false


func is_dragging_over_area(event: InputEvent) -> bool:
	if not event.is_pressed():
		return false
	if not event is InputEventScreenDrag:
		return false
	if %BoardTouchArea2D.registered_touch_event == null:
		return false
	if event.index != %BoardTouchArea2D.registered_touch_event.index:
		return false
	
	return true


func is_released(event) -> bool:
	return event is InputEventScreenTouch and not event.is_pressed()


func _process_board_touch_highlighting():
#	unhighlight_all_panel_pieces()
	
	for pp in %PanelPieces.get_children():
		if pp.is_tapping_over:
			highlight_linked_panel_pieces(pp)


# Connected from creation of PanelPiece
func _on_panel_piece_destroy_requested(panel_piece: PanelPiece):
	destroy_panel_piece(panel_piece)


func _on_panel_pieces_child_exiting_tree(node):
	# Awake all children nodes of Rigidbody2D
	for panel_piece in %PanelPieces.get_children():
		if panel_piece == node: # ไม่ลูปกับโหนดที่กำลังถูกลบออกจาก tree
			continue
		
		if panel_piece is RigidBody2D:
			panel_piece.sleeping = false
	
	spawn_panel_piece()


func _on_board_touch_area_2d_touch_registered(event) -> void:
	_process_board_touch_highlighting()
