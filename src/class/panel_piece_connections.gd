class_name PanelPieceConnections extends Object


var neighbors: Array[PanelPiece]


func add_neighbor(source: PanelPiece, myself: PanelPiece):
	if source == myself:
		return
	if source.type != myself.type:
		return
	if neighbors.has(source):
		return
	
	neighbors.append(source)


func remove_neighbor(source: PanelPiece):
	if not neighbors.has(source):
		return
	
	neighbors.remove_at(neighbors.find(source))


func get_linked_pieces(from: PanelPiece, exclude_from: bool = false) -> Array[PanelPiece]:
	var panel_queue: Array[PanelPiece]
	var paired_panels: Array[PanelPiece]
	panel_queue.append(from)
	paired_panels.append(from)
	
	while not panel_queue.is_empty():
		for i in panel_queue:
			for j in i.piece_connections.neighbors:
				if paired_panels.has(j):
					continue
				
				paired_panels.append(j)
				panel_queue.append(j)
			
			panel_queue.remove_at(panel_queue.find(i))
	
	if exclude_from:
		paired_panels.remove_at(paired_panels.find(from))
	
	return paired_panels
