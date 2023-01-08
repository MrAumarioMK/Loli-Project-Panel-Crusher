extends Node2D


const PANEL_PIECE = preload("res://src/scenes/game/panel_piece.tscn")


@export var max_panel_pieces: int = 50


var touching_panel_pieces: Array[PanelPiece]


func _ready():
	for i in max_panel_pieces: # *First 2022-12-26 collision ทุกตัวแย่งที่อยู่กัน ทำให้มี spawn ออกนอก board ไว้ค่อยมาแก้
		spawn_panel_piece()


func _input(event: InputEvent):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		highlight_linked_panel_pieces()
	
	if event is InputEventScreenTouch:
		if not event.is_pressed() and is_board_touch_area_registered_by_idx_of(event.index):
			%BoardTouchArea2D.unregister_touch()


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
		_on_panel_piece_destroy_requested
	)
	pp.touch_hitbox_entered.connect(
		_on_panel_piece_touch_hitbox_entered
	)
	pp.touch_hitbox_exited.connect(
		_on_panel_piece_touch_hitbox_exited
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


func highlight_linked_panel_pieces():
	unhighlight_all_panel_pieces()
	for tpp in touching_panel_pieces:
		var linked_pieces = tpp.piece_connections.get_linked_pieces(tpp)
		for pp in linked_pieces:
			pp.highlight = true


func unhighlight_all_panel_pieces():
	for pp in %PanelPieces.get_children():
		pp.highlight = false


func is_released(event) -> bool:
	return event is InputEventScreenTouch and not event.is_pressed()


func is_board_touch_area_registered_by_idx_of(idx: int) -> bool:
	return %BoardTouchArea2D.registered_touch_event != null and idx == %BoardTouchArea2D.registered_touch_event.index


# Connected from creation of PanelPiece
func _on_panel_piece_destroy_requested(panel_piece: PanelPiece, touch_idx: int):
	if is_board_touch_area_registered_by_idx_of(touch_idx):
		destroy_panel_piece(panel_piece)
		touching_panel_pieces.erase(panel_piece)


# Connected from creation of PanelPiece
func _on_panel_piece_touch_hitbox_entered(panel_piece: PanelPiece, touch_idx: int):
	if is_board_touch_area_registered_by_idx_of(touch_idx):
		touching_panel_pieces.append(panel_piece)
		highlight_linked_panel_pieces()


# Connected from creation of PanelPiece
func _on_panel_piece_touch_hitbox_exited(panel_piece: PanelPiece, touch_idx: int):
	if is_board_touch_area_registered_by_idx_of(touch_idx):
		touching_panel_pieces.erase(panel_piece)


func _on_panel_pieces_child_exiting_tree(node):
	# Awake all children nodes of Rigidbody2D
	for panel_piece in %PanelPieces.get_children():
		if panel_piece == node: # ไม่ลูปกับโหนดที่กำลังถูกลบออกจาก tree
			continue
		
		if panel_piece is RigidBody2D:
			panel_piece.sleeping = false
	
	spawn_panel_piece()
