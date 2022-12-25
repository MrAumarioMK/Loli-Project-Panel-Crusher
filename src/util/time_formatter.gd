# Desc:
#   Converts seconds into human-readable string.


class_name TimeFormatter extends Object


const TEXT_SECOND = "s"

const TEXT_MINUTE = "m"

const TEXT_HOUR = "h"

const TEXT_DAY = "d"

const SEC_MINUTE = 60

const SEC_HOUR = 3600

const SEC_DAY = 86400

const MODULO_SECOND = 60

const MODULO_MINUTE = 60

const MODULO_HOUR = 24


# Returns seconds converted into human-readable time. A 60 seconds or greater
# will return a 1 minute, a 60 minutes or greater returns a 1 hour, and so on.
# A secondary value can be omitted when `shortened` is set to true.
#
# Ex:
#     get_time_format(15) # returns 15s
#     get_time_format(60) # returns 1m
#     get_time_format(62) # returns 1m 2s
#     get_time_format(1500) # returns 25m
#     get_time_format(3600) # returns 1h
#     get_time_format(3907) # returns 1h 5m
#     get_time_format(2.5) # returns 2s
#     get_time_format(86400) # returns 1d
static func get_time_format(seconds: float, shortened:= false) -> String:
	var txt: String
	
	if seconds < SEC_MINUTE:
		txt += str(get_second(seconds), TEXT_SECOND)
		
	elif seconds < SEC_HOUR:
		txt += str(get_minute(seconds), TEXT_MINUTE)
		
		# Append seconds text if it is not a zero number
		if get_second(seconds) != 0 and not shortened:
			txt += " " + str(get_second(seconds), TEXT_SECOND)
		
	elif seconds < SEC_DAY:
		txt += str(get_hour(seconds), TEXT_HOUR) 
		
		# Append minutes text if it is not a zero number
		if get_minute(seconds) != 0 and not shortened:
			txt += " " + str(get_minute(seconds), TEXT_MINUTE)
		
	else:
		txt += str(get_day(seconds), TEXT_DAY)
		
		# Append hours text if it is not a zero number
		if get_hour(seconds) != 0 and not shortened:
			txt += " " + str(get_hour(seconds), TEXT_HOUR)
		
	
	return txt


static func get_second(seconds: float) -> int:
	return int(seconds) % MODULO_SECOND


static func get_minute(seconds: float) -> int:
	return int(seconds / SEC_MINUTE) % MODULO_MINUTE


static func get_hour(seconds: float) -> int:
	return int(seconds / SEC_HOUR) % MODULO_HOUR


static func get_day(seconds: float) -> int:
	return int(seconds / SEC_DAY)
