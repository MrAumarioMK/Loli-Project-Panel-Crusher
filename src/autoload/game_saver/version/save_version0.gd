# Desc:
#   An example of save versioning.
#   You can name the class and the script to something like save_version_1.gd,
#   save_version_1_0_1.gd, save_version_2_0, etc.
#   The version zero (this class) is reserved for copy-pasting so that you will
#   be able to implement your own versions without stepping on each other's
#   toes.


class_name SaveVersion0 extends SaveVersion


# An example of a must-have method for this class
static func upgrade(data: SaveGame):
	if Version.parse(data.version).compare(Version.parse("0.0.1")) == Version.OLDER:
		return
	
	# Case when data is a ConfigFile (default)
	if data.data.has_section_key("environment", "hard_mode_enabled"):
		data.data.set_value(
			"world",
			"hard_mode_enabled",
			data.get_value("environment", "hard_mode_enabled"),
			)
		data.data.erase_section_key("environment", "hard_mode_enabled")
	
