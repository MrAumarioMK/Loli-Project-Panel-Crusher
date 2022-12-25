# Desc:
# 	A representation of a version string.


class_name Version extends Object


# Semantic Version String like 1.0.0-beta.
# See https://semver.org/spec/v2.0.0.html for more info
# and https://regex101.com/r/vkijKf/1/ to validate your version string
const REGEX_PATTERN = "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$"

const OLDER = -1
const UP_TO_DATE = 0
const NEWER = 1


# List of parsed string containing version number.
# The first element always contain full string followed by the next three
# corresponding to version numbers: MAJOR.MINOR.PATCH, and the next 2 elements
# are optional prerelease and buildmetadata.
var version: PackedStringArray


func _init(_version_string: PackedStringArray):
	version = _version_string


# Method to compare this version to another.
# Returns 1 if v1 > v2 (Newer)
# Returns -1 if v1 < v2 (Older)
# Returns 0 if v1 == v2 (Up to Date)
func compare_to(v: Version) -> int:
	var v1 = self.version
	var v2 = v.version
	
	# Ignores the first full text and the last two optional identifiers
	v1.remove_at(0)
	v1.remove_at(v1.size() - 1)
	v1.remove_at(v1.size() - 1)
	v2.remove_at(0)
	v2.remove_at(v2.size() - 1)
	v2.remove_at(v2.size() - 1)
	
	for i in v1.size():
		var num_v1 = v1[i].to_int()
		var num_v2 = v2[i].to_int()
	
		if num_v1 > num_v2:
			return NEWER
		if num_v1 < num_v2:
			return OLDER
	
	return UP_TO_DATE


# Returns a string representation of this version.
func get_text() -> String:
	return version[0]


func major() -> String:
	return version[1]


func minor() -> String:
	return version[2]


func patch() -> String:
	return version[3]


func build_info() -> String:
	return version[4]


static func parse(s: String) -> Version:
	var version_strings = _get_version_strings(s)
	assert(not version_strings.is_empty(), "Invalid semantic version string.")
	return Version.new(version_strings)


static func _get_version_strings(s: String) -> PackedStringArray:
	var regex = RegEx.new()
	regex.compile(REGEX_PATTERN)
	var regex_result = regex.search(s)
	var version_strings: PackedStringArray
	if regex_result:
		version_strings = regex_result.strings
	
	return version_strings


static func _is_simple_number(s: String) -> bool:
	if s == "":
		return false
	
	for i in s.length():
		var c = s[i]
		var lower_bound = "0" if i > 0 else "1"
		if c < lower_bound or c > "9":
			return false
	
	return true
