extends Node2D


@export var panel_piece: PackedScene


const MAX_PANEL_PIECE_COUNT = 50


func _process(delta):
	if get_panel_pieces_count() < MAX_PANEL_PIECE_COUNT:
		spawn_panel(get_random_spawn_position())


func spawn_panel(spawn_global_position):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pp = panel_piece.instantiate()
	%PanelPieces.add_child(pp)
	pp.global_position = spawn_global_position
	pp.type = rng.randi_range(1, 5)
	pp.rotation = rng.randf_range(0, 2 * PI)


func get_panel_pieces_count() -> int:
	return %PanelPieces.get_child_count()


func get_random_spawn_position() -> Vector2:
	var p1 = %SpawnLine.get_point_position(0)
	var p2 = %SpawnLine.get_point_position(1)
	var pos = p1.lerp(p2, randf())
	
	return pos


func _on_panel_pieces_child_exiting_tree(node):
	# Awake all children nodes of Rigidbody2D
	for panel_piece in %PanelPieces.get_children():
		if panel_piece == node: # ไม่ลูปกับโหนดที่กำลังถูกลบออกจาก tree
			continue
		
		if panel_piece is RigidBody2D:
			panel_piece.sleeping = false
