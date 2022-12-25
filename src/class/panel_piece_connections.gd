class_name PanelPieceConnections extends Object


var pairs: Array[PanelPiece]


func pair(source: PanelPiece, myself: PanelPiece):
	if source == myself:
		return
	if source.type != myself.type:
		return
	if pairs.has(source):
		return
	
	pairs.append(source)


func unpair(source: PanelPiece):
	if not pairs.has(source):
		return
	
	pairs.remove_at(pairs.find(source))


func get_linked_pieces(from: PanelPiece, exclude_from: bool = false) -> Array[PanelPiece]:
	var panel_queue: Array[PanelPiece]
	var paired_panels: Array[PanelPiece]
	panel_queue.append(from)
	paired_panels.append(from)
	
	while not panel_queue.is_empty():
		for i in panel_queue:
			for j in i.piece_connections.pairs:
				if paired_panels.has(j):
					continue
				
				paired_panels.append(j)
				panel_queue.append(j)
			
			panel_queue.remove_at(panel_queue.find(i))
	
	if exclude_from:
		paired_panels.remove_at(paired_panels.find(from))
	
	return paired_panels
