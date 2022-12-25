class_name DigitFormatter extends Object


const DEFAULT_SEPARATOR = ","


# Converts number to seperated-commas text by casting the number to a string.
# Ex:
#     get_text(12345) # returns 12,345
#     get_text(600000) # returns 600,000
#     get_text(1500) # returns 1,500
#     get_text(950010000) # returns 950,010,000
#     get_text(2.123456) # returns 2.123456
#     get_text(4231.235) # returns 4,231.235
#     get_text(-31257) # returns -31,257
static func get_text(number, separator = DEFAULT_SEPARATOR) -> String:
	var text:= str(number)
	var iterated_integer: int
	var is_pointer_decimal = text.find(".") > -1
	var text_pool: PackedStringArray
	var is_minus_value = number < 0
	
	# Apply adding commas and a full stop (if the number is a decimal value)
	# by iterating through String backwards.
	for i in range(text.length() - 1, -1, -1):
		text_pool.append(text[i])
		
		if is_pointer_decimal:
			if text[i] == ".":
				is_pointer_decimal = false
			
			continue
		
		# Exits the loop when at the end of the iteration (or nearly at the end
		# if the number is a negative value) so that seperator may not need
		# to be appended anymore.
		if is_minus_value and i == 1:
			text_pool.append("-")
			break
		if i == 0:
			break
		
		iterated_integer += 1
		
		if iterated_integer % 3 == 0:
			text_pool.append(separator)
	
	text_pool.reverse()
	return "".join(text_pool)
