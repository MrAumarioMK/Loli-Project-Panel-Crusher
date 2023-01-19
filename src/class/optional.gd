# Desc:
# 	A container object which may or may not contain a non-null value. If a
# 	value is present, is_present() will return true and get() will return the 
# 	value.
# 	
# 	Additional methods that depend on the presence or absence of a contained
# 	value are provided, such as or_else() (return a default value if value not
# 	present) and if_present() (execute a block of code if the value is present).
# 	
# 	This is a value-based class; use of identity-sensitive operations
# 	(including reference equality (==), identity hash code, or synchronization)
# 	on instances of Optional may have unpredictable results and should be
# 	avoided.

class_name Optional extends Object


var _value


func _init(value: Variant = null):
	_value = value


# Returns an empty Optional instance. No value is present for this Optional.
static func empty() -> Optional:
	return Optional.new()


# Returns an Optional with the specified value.
static func of(value: Variant) -> Optional:
	return Optional.new(value)


# If the value is present in this Optional, returns the value, otherwise an
# assertion error is generated.
func get_value() -> Variant:
	assert(_value != null, "No value present.")
	return _value


# Return the value if present, otherwise return other.
func or_else(other: Variant) -> Variant:
	return _value if _value != null else other


# Returns true if there is a value present, otherwise false.
func is_present() -> bool:
	return _value != null
