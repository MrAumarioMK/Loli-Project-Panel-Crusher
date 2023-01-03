extends Area2D


signal touch_registered(event)


var registered_touch_event: InputEventScreenTouch


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed() and not is_touch_registered():
		register_touch(event)
		emit_signal("touch_registered", event)


func can_unregister_touch(unpressed_event: InputEvent) -> bool:
	if not unpressed_event is InputEventScreenTouch:
		return false
	if unpressed_event.is_pressed():
		return false
	if not is_touch_registered():
		return false
	if registered_touch_event == null:
		return false
	if unpressed_event.index != registered_touch_event.index:
		return false
	
	return true


func is_touch_registered() -> bool:
	return registered_touch_event != null


func register_touch(event: InputEventScreenTouch):
	registered_touch_event = event
	print(self, " touch registered")


func unregister_touch():
	registered_touch_event = null
	print(self, " touch unregistered")
