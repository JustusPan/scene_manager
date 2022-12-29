@tool
extends ScrollContainer

@onready var _container: VBoxContainer = find_child("container")
@onready var _scene_item = preload("res://addons/scene_manager/scene_item.tscn")
@onready var _root: Node = self
@onready var _delete_list_button: Button = self.find_child("delete_list")
@onready var _duplicate_line_edit: StyleBox = load("res://addons/scene_manager/themes/line_edit_duplicate.tres")
@onready var _normal_line_edit: StyleBox = load("res://addons/scene_manager/themes/line_edit_normal.tres")

# Finds and fills `_root` variable properly
#
# Start up of `All` list
func _ready() -> void:
	if self.name == "All":
		_delete_list_button.icon = null
		_delete_list_button.disabled = true
		_delete_list_button.focus_mode = Control.FOCUS_NONE
	while true:
		if _root != null && _root.name == "Scene Manager" || _root.name == "menu":
			break
		_root = _root.get_parent()

# Adds an item to list
func add_item(key: String, value: String) -> void:
	var item = _scene_item.instantiate()
	item.set_key(key)
	item.set_value(value)
	_container.add_child(item)

# Removes an item from list
func remove_item(key: String, value: String) -> void:
	for i in range(_container.get_child_count()):
		if i == 0: continue
		var child: Node = _container.get_child(i)
		if child.get_key() == key && child.get_value() == value:
			child.queue_free()
			return

# Removes items that their value begins with passed value
func remove_items_begins_with(value: String) -> void:
	for i in range(_container.get_child_count()):
		if i == 0: continue
		var child: Node = _container.get_child(i)
		if child.get_value().begins_with(value):
			child.queue_free()

# Clear all scene records from UI list
func clear_list() -> void:
	for i in range(_container.get_child_count()):
		if i == 0: continue
		_container.get_child(i).queue_free()

# Appends all scenes into UI list
func append_scenes(nodes: Dictionary) -> void:
	for key in nodes:
		add_item(key, nodes[key])

# Return an array of record nodes from UI list
func get_list_nodes() -> Array:
	var arr: Array = []
	for i in range(_container.get_child_count()):
		if i == 0: continue
		arr.append(_container.get_child(i))
	return arr

# Update a specific scene record with passed data in UI
func update_scene_with_key(key: String, new_key: String, value: String) -> void:
	for i in range(_container.get_child_count()):
		if i == 0: continue
		var child: Node = _container.get_child(i)
		if child.get_key() == key && child.get_value() == value:
			child.set_key(new_key)

# Checks duplication in current list and return their scene addresses in an array from UI
func check_duplication() -> Array:
	var arr: Array = []
	for i in range(_container.get_child_count()):
		if i == 0: continue
		var j: int = i + 1
		while j < _container.get_child_count():
			var child1: Node = _container.get_child(i)
			var child2: Node = _container.get_child(j)
			if child1.get_key() == child2.get_key():
				if !(child1.get_key() in arr):
					arr.append(child1.get_key())
			j += 1
	return arr

# Reset theme for all children in UI
func set_reset_theme_for_all() -> void:
	for i in range(_container.get_child_count()):
		if i == 0: continue
		var child: Node = _container.get_child(i)
		child.custom_set_theme(_normal_line_edit)

# Sets duplicate theme for children in passed list in UI
func set_duplicate_theme(list: Array) -> void:
	for i in range(_container.get_child_count()):
		if i == 0: continue
		var child: Node = _container.get_child(i)
		if child.get_key() in list:
			child.custom_set_theme(_duplicate_line_edit)

# List deletion
func _on_delete_list_button_up() -> void:
	if self.name == "All":
		return
	self.queue_free()
