# Desc:
# 	A class that detects when a primitive value become unique or
# 	equal to a defined value. Emits a signal when condition is met.

# Usage:
# 	var vsignal_is_on_floor = VarSignalEmitter.register(
# 		is_on_floor, self, "test")
# 	
# 	vsignal_is_on_floor.set_value(is_on_floor)
# 	vsignal_is_on_floor.try_emit()
# 	
# 	is_on_floor = vsignal_is_on_floor.set_value(true) # Emits
# 	vsignal_is_on_floor.try_emit()
# 	
# 	is_on_floor = vsignal_is_on_floor.set_value(true)
# 	vsignal_is_on_floor.try_emit()
# 	
# 	is_on_floor = vsignal_is_on_floor.set_value(false) # Emits
# 	vsignal_is_on_floor.try_emit()

class_name VarSignalEmitter extends Object


var current_value: Variant

var emitter: Object

var signal_name: String

var value_condition: Variant

var _can_emit: bool


func _init(new_value: Variant, new_emitter: Object, new_signal_name: String, val_condition: Variant = null):
	current_value = new_value
	emitter = new_emitter
	signal_name = new_signal_name
	value_condition = val_condition


static func register(
	new_value: Variant, 
	new_emitter: Object, 
	new_signal_name: String,
	val_condition: Variant = null
	) -> VarSignalEmitter:
	return VarSignalEmitter.new(new_value, new_emitter, new_signal_name, val_condition)


func set_value(value: Variant) -> Variant:
	_can_emit = (
		(value_condition == null and value != current_value)
		or (value_condition != null and value != current_value and value == value_condition)
	)
	
	current_value = value
	return value


func try_emit() -> bool:
	if not _can_emit:
		return false
	
	emitter.emit_signal(signal_name)
	return true
