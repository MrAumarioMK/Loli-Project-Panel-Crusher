extends Area2D


signal touch_registered(event)


var registered_touch_event: InputEventScreenTouch


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed() and not is_touch_registered():
		register_touch(event)
		emit_signal("touch_registered", event)


func is_touch_registered() -> bool:
	return registered_touch_event != null


func register_touch(event: InputEventScreenTouch):
	registered_touch_event = event


func unregister_touch():
	registered_touch_event = null
