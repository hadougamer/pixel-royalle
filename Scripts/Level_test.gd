extends Node2D

var pre_player=preload("res://Scenes/Player.tscn")
var cur_player # Current player

func _ready():
	# Add the player
	cur_player = Globals.add_player( 
		get_tree().get_root(),
		get_tree().get_network_unique_id(),
		Network.self_data.name
	)