extends Node2D


const PANEL_PIECE = preload("res://src/scenes/game/panel_piece.tscn")


@export var max_panel_pieces: int = 50


func _ready():
	for i in max_panel_pieces: # *First 2022-12-26 มี spawn ออกนอก board ค่อยมาแก้
		spawn_panel_piece()


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
	return pp


func get_random_spawn_position() -> Vector2:
	var p1 = %SpawnLine.get_point_position(0)
	var p2 = %SpawnLine.get_point_position(1)
	var pos = p1.lerp(p2, randf())
	
	return pos


func get_panel_pieces_count() -> int:
	return %PanelPieces.get_child_count()


func _on_panel_pieces_child_exiting_tree(node):
	# Awake all children nodes of Rigidbody2D
	for panel_piece in %PanelPieces.get_children():
		if panel_piece == node: # ไม่ลูปกับโหนดที่กำลังถูกลบออกจาก tree
			continue
		
		if panel_piece is RigidBody2D:
			panel_piece.sleeping = false
	
	spawn_panel_piece()
