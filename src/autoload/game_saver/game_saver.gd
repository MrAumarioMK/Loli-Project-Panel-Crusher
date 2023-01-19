# Desc:
#   AutoLoad Script
#   
#   Saves and loads savegame files.
#   Each node is responsible for finding itself in the save_game
#   dict so saves don't rely on the nodes' path or their source file.

# Usage:
#   Please refer to `docs/SaveGame.md` for more details.

# NOTE:
#   I Should have set this as a static class. However, a function get_tree()
#   requires that the base self must be an instance of Node for it to work.
#   If you have a workaround, please find the way how each node will find
#   their GroupNode without making this class depend only on the base class of
#   Node.


extends Node


const SAVE_GROUP_NAME = "Save"

const PROJECT_VERSION_PATH = "application/config/version"

# If not defined other than an empty string, no save encryption will be used
const SAVE_ENCRYPTED_PASS = ""

const SAVE_PATH: String = "user://save.cfg"


func _ready() -> void:
	if not ProjectSettings.has_setting(PROJECT_VERSION_PATH):
		push_error(str(
			PROJECT_VERSION_PATH,
			" is not defined in the Project > ProjectSettings.",
			" It is encouraged to add it to support older versions of",
			" save files in the future."
		))
	if SAVE_ENCRYPTED_PASS == "":
		push_warning("Save encrypt password is empty.")


# Saves everything into disk by calling every nodes within the scene tree
# that are in group of 'Save' (refering to a const SAVE_GROUP_NAME) and passes
# all of their data into this function.
func save_game():
	var _save_game: SaveGame = get_save_game()
	
	# Begin the saving process
	var error: int
	if SAVE_ENCRYPTED_PASS == "":
		error = _save_game.data.save(SAVE_PATH)
	else:
		error = _save_game.data.save_encrypted_pass(SAVE_PATH, SAVE_ENCRYPTED_PASS)
	
	assert(error == OK, "There was an issue writing the save to")
	
	if error == OK:
		print_debug("Game saved")
	else:
		print_debug("Game not saved. Error code: ", error)


# Reads a saved game from the disk and delegates loading
# to the individual nodes to load
func load_game():
	var _save_game:= SaveGame.new()
	var error: int
	
	if SAVE_ENCRYPTED_PASS == "":
		error = _save_game.data.load(SAVE_PATH)
	else:
		error = _save_game.data.load_encrypted_pass(SAVE_PATH, SAVE_ENCRYPTED_PASS)
	
	if error != OK:
		print_debug("Game not loaded. Error code: ", error)
		return
	
	# Make version of the loaded save file up to date with the game if possible
	_save_game.game_version = _save_game.data.get_value("version", "version", "")
	var save_ver_controller = SaveVersioningController.new()
	save_ver_controller.manipulate(_save_game)
	
	for node in get_tree().get_nodes_in_group(SAVE_GROUP_NAME):
		node._load(save_game)
	
	print_debug("Game loaded")


# Deletes save game from the user://save permanently.
func delete_save_game():
	var dir = DirAccess.new()
	dir.remove(SAVE_PATH)
	
	print_debug("Save file removed from the user device.")


func get_save_game() -> SaveGame:
	var _save_game:= SaveGame.new()
	
	# Set save version (version of the game)
	if ProjectSettings.has_setting(PROJECT_VERSION_PATH):
		_save_game.game_version = ProjectSettings.get_setting(PROJECT_VERSION_PATH)
	
	# Assign version to the save file
	_save_game.data.set_value("version", "version", _save_game.game_version)
	
	# Iterate through nodes which are in group of 'Save' and call a method
	# "save". If the method is not implemented in that node, pushes an error.
	for node in get_tree().get_nodes_in_group(SAVE_GROUP_NAME):
		if node.has_method("_save"):
			node._save(_save_game)
		else:
			push_error(str(node, " is in group ", SAVE_GROUP_NAME, ", but doesn't have a method _save() implemented. If this is not intended, remove ", SAVE_GROUP_NAME, " from Groups."))
	
	return _save_game

