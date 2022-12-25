# Desc:
#   A generic percentage class


class_name Percent extends Object


const FULL_PERCENT = 1.00

const ZERO_PERCENT = 0.00

const ONE_PERCENT = 0.01


# Returns human-readable percent number as text.
# Ex:
#     get_percent_text(0.15) # returns 15%
#     get_percent_text(0.1248) # returns 12.48%
#     get_percent_text(0.124) # returns 12.4%
#     get_percent_text(2.05) # returns 205%
static func get_percent_text(raw_float: float, step = 0.01) -> String:
	return str(get_percent(raw_float, step), "%")


# Returns human-readable percent number.
# Ex: 
#     get_full_percent(0.5) # returns 50
#     get_full_percent(0.15) # returns 15
#     get_full_percent(-4) # returns -400
#     get_full_percent(-0.4) # returns -40
static func get_percent(raw_float: float, step = 0.01) -> float:
	return snapped(raw_float * 100, step)


# Returns a raw percent between two values
# Ex:
#     get_percentage(10, 200) # returns 0.05
#     get_percentage(1500, 3000) # returns 0.5
#     get_percentage(250, 125) # returns 2
#     get_percentage(50, 0) # returns 0
static func get_percentage(raw_value, max_value) -> float:
	if max_value == 0:
		return 0.0
	
	return raw_value / float(max_value)

