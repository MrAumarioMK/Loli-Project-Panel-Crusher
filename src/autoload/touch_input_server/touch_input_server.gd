# Autoload
extends Node2D


const MAX_TOUCH_POINTS = 11

const TOUCH_HITBOX = preload("res://src/autoload/touch_input_server/touch_hitbox.tscn")


# Structure:
# 	index:int {
# 		pressed: bool,
# 		position: Vector2,
# 		relative: Vector2,
# 		velocity: Vector2,
# 		touch_hitbox: TouchHitbox,
# 	}, ...
var indexes: Dictionary

var active_indexes: Array[int]


func _ready() -> void:
	# prepare nested dictionaries
	for i in MAX_TOUCH_POINTS:
		var touch_hitbox = TOUCH_HITBOX.instantiate()
		$CanvasLayer.add_child(touch_hitbox)
		touch_hitbox.index = i
		
		indexes[i] = {
			"pressed": false,
			"position": Vector2(),
			"relative": Vector2(),
			"velocity": Vector2(),
			"touch_hitbox": touch_hitbox,
		}


func _input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			_touch_enter(event)
		else:
			_touch_exit(event)
	
	if event is InputEventScreenDrag:
		_touch_move(event)


func get_active_indexes_count() -> int:
	return active_indexes.size()


func is_touch_pressed(idx: int) -> bool:
	return indexes[idx]["pressed"]


func get_touch_position(idx: int) -> bool:
	return indexes[idx]["pressed"]


func get_touch_relative(idx: int) -> bool:
	return indexes[idx]["pressed"]


func get_touch_velocity(idx: int) -> bool:
	return indexes[idx]["pressed"]


func get_touch_hitbox(idx: int) -> TouchHitbox:
	return indexes[idx]["touch_hitbox"]


func _touch_enter(event: InputEventScreenTouch):
	indexes[event.index]["pressed"] = true
	indexes[event.index]["position"] = true
	indexes[event.index]["relative"] = true
	indexes[event.index]["velocity"] = true
	active_indexes.append(event.index)
	get_touch_hitbox(event.index).update_active(true)
	get_touch_hitbox(event.index).update_position(event.position)


func _touch_move(event: InputEventScreenDrag):
	indexes[event.index]["position"] = event.position
	indexes[event.index]["relative"] = event.relative
	indexes[event.index]["velocity"] = event.velocity
	get_touch_hitbox(event.index).update_position(event.position)


func _touch_exit(event: InputEventScreenTouch):
	indexes[event.index]["pressed"] = false
	active_indexes.erase(event.index)
	get_touch_hitbox(event.index).update_active(false)
	get_touch_hitbox(event.index).update_position(event.position)
