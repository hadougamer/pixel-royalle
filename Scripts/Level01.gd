extends Node2D

var pre_player=preload("res://Scenes/Player.tscn")
var cur_player # Current player

func _ready():
	
	cur_player = add_player( 
		get_tree().get_network_unique_id(), 
		$PlayerPositions.get_child(0).global_position 
	)

	var enemy = add_player( 
		Globals.enemies_ids[0], 
		$PlayerPositions.get_child( randi()%10 ).global_position 
	)

func add_player( player_id, position ):
	print( "Adding player: " + str(player_id) )
	
	var player = pre_player.instance()
	player.player_name = str( str( player_id ) )
	player.set_name(str( player_id ))
	player.set_network_master( player_id )
	player.global_position = position
	add_child(player)

	return player

func _process(delta):
	if cur_player:
		# Camera limits
		$Camera.limit_left = 0
		$Camera.limit_right = 6750
		$Camera.limit_bottom = 600
		
		# Updates camera according to player
		$Camera.position.y = cur_player.position.y
		$Camera.position.x = cur_player.position.x + 310
