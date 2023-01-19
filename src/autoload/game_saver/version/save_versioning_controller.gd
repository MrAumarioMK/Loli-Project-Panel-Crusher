# Desc:
#   A controller class responsible for managing save data

class_name SaveVersioningController extends Object


# Version classes that will be executed in order.
# Ex: SaveVersion1, SaveVersion2, ...
var versions = [
	
]


func manipulate(save_data) -> SaveGame:
	assert(save_data != null)
	
	for save_version in versions:
		save_version.upgrade(save_data)
	
	return save_data
