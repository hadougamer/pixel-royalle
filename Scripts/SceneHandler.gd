extends Node

var start_scene = preload("res://Scenes/Network_setup.tscn")

func _ready():
	var cur_scene = start_scene.instance()
	add_child( cur_scene )
