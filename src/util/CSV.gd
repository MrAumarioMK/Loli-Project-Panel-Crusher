# Desc:
#   Reads a whole text (usually obtained from a csv file) and converts it into
#   a datatype.

# Usage:
#   id	name	atk
#   0 	Ike 	64
#   1 	Jean	32
#   2 	Rai 	15
#   
#   get_array(csv_text, "	") -> # returns
#   # [
#   # 	[0, "Ike", 64],
#   # 	[1, "Jean", 32],
#   # 	[2, "Rai", 15]
#   # ]
#   
#   
#   get_array(csv_text, "	", true) -> # returns
#   # [
#   # 	[id, name, atk],
#   # 	[0, "Ike", 64],
#   # 	[1, "Jean", 32],
#   # 	[2, "Rai", 15]
#   # ]
#   
#   Getting a text in CSV will always have their values undesired. Most values
#   are usually in String datatype which means if the data is a number there
#   will be no way to correctly convert it.
#   
#   In `get_array()` when setting `parse_number` to true, value that can be a
#   number will automatically be converted, however this may have small errors.
#   For example, you may accidentially convert a value that is actually a
#   String but you do not wish it to be converted into a number.
#   
#   To minimalize errors in number conversion process, the data should be
#   carefully designed, e.g. "423", "3.15" are practically both a valid value
#   for conversion while "250hp", "atk:420" and values similar to these will be
#   left as it is without converting it.


class_name CSV extends Object


static func get_array(csv_text: String, delimiter: String, include_header:= false, parse_numbers:= true) -> Array:
	var result = []
	var lines: PackedStringArray = csv_text.split("\n")
	
	for i in lines.size():
		if not include_header and i == 0:
			continue
		
		# Ex: [0, "Ike", 64]
		var spilted_values = (str(lines[i])).split(delimiter)
		var values = Array(spilted_values)
		
		if parse_numbers:
			for j in values.size():
				if values[j].is_valid_float():
					if values[j].is_valid_int():
						values[j] = values[j].to_int()
					else:
						values[j] = values[j].to_float()
		
		result.append(values)
	
	return result


static func get_header(csv_text: String, delimiter: String) -> Array:
	var result = []
	var lines: PackedStringArray = csv_text.split("\n")
	
	if not lines.is_empty():
		result = Array((str(lines[0])).split(delimiter))
	
	return result
