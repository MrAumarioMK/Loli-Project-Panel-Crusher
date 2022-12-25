# Desc:
#   Automatically adjusts the physics fps to match with the current running
#   fps.
#   
#   By default, the physics fps is at 60 and will not always synchronize with
#   the monitor's frame rate. At any time the monitor's frame rate changes,
#   this class will handle the physics fps to be synchronized with the
#   monitor's running fps to prevent stutters.

# TODO:
#   Change physics fps to match with current fps instead.


extends Node


const AVERAGE_MAX_COUNT = 12


var fps_values: Array
var last_set_physics_fps: int


func adjust():
	var current_fps = Performance.get_monitor(Performance.TIME_FPS)
	
	# Append new number to average pool. If the pool size exceeds the limit,
	# the oldest value is removed.
	fps_values.append(current_fps)
	if fps_values.size() > AVERAGE_MAX_COUNT:
		fps_values.pop_front()
	
	Engine.physics_ticks_per_second = get_highest_num(fps_values)
	last_set_physics_fps = Engine.physics_ticks_per_second


func get_highest_num(arr: Array) -> int:
	var best:= 60
	
	for value in arr:
		if value > best:
			best = value
	
	return best


func _on_physics_fps_update_timer_timeout():
	adjust()
