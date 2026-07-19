extends Node
class_name GlobalVariables

static var dictionary = {}

static func get_field(field):
	return dictionary.get(field)

static func set_field(field, value):
	dictionary.set(field, value)
