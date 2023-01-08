# Desc:
# 	A label which displays a list of property values in any Object
# 	instance, suitable for both in-game and editor debugging.
# 	
# 	Script credit: https://github.com/godot-extended-libraries/godot-next

# Usage:
# 	var debug_label = DebugLabel.new(node)
# 	debug_label.watchv(["position:x", "scale", "rotation"])

@tool
extends Label


# Advanced: depending on the properties inspected, you may need to switch
# to either "IDLE" or "PHYSICS" update mode to avoid thread issues.
enum UpdateMode {
	IDLE,
	PHYSICS,
	MANUAL,
}


@export_node_path(Node) var root_node_path:
	set(value):
		root_node_path = value
		if value != null and is_inside_tree():
			root_node = get_node(root_node_path)
		if value == null:
			root_node_path = get_path_to(get_parent())

# A list of property names to be inspected and printed in the `root_node`.
# Use indexed syntax (:) to access nested properties: "position:x".
# Indexing will also work with any `onready` vars defined via script.
# These can be set beforehand via inspector or via code with watch().
@export var properties: PackedStringArray

@export var update_mode: UpdateMode

@export var show_root_node_name: bool


var root_node: Node:
	get:
		if root_node == null and root_node_path != null:
			return get_node(root_node_path)
		
		return root_node


func _process(delta):
	if Engine.is_editor_hint():
		return
	if update_mode == UpdateMode.IDLE:
		_update_debug_info()


func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	if update_mode == UpdateMode.PHYSICS:
		_update_debug_info()


func watch(p_what: String) -> void:
	properties = PackedStringArray([p_what])


func watchv(p_what: PackedStringArray) -> void:
	properties = p_what


func watch_append(p_what: String) -> void:
	properties.append(p_what)


func watch_appendv(p_what: PackedStringArray) -> void:
	properties.append_array(p_what)


func clear() -> void:
	properties = PackedStringArray()


# Need to be call manually if update mode is operating in Manual
func update():
	_update_debug_info()


func _update_debug_info():
	text = ""
	
	if show_root_node_name:
		text += "%s\n" % [root_node.name]
	
	for property in properties:
		var object_property = var_to_str(root_node.get_indexed(property))
		text += "%s = %s\n" % [property, object_property]
