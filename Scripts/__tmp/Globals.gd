extends Node

var cur_scene
var pre_player = preload("res://Scenes/Player.tscn")

func add_player( name, id, position ):
	var new_player = pre_player.instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id)
	new_player.player_name = name
	new_player._id = str(id)
	new_player.global_position = position

	cur_scene.add_child(new_player)
	return new_player