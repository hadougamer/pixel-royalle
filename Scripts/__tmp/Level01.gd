extends Node2D

var pre_player=preload("res://Scenes/Player.tscn")
var cur_player # Current player

func _ready():
	# Add the player
	cur_player = Globals.add_player( 
		Network.self_data.name, 
		get_tree().get_network_unique_id(), 
		Network.self_data.position
	)

func _process(delta):
	if cur_player:
		# Camera limits
		$Camera.limit_left = 0
		$Camera.limit_right = 6750
		$Camera.limit_bottom = 600
		
		# Updates camera according to player
		$Camera.position.y = cur_player.position.y
		$Camera.position.x = cur_player.position.x + 310
