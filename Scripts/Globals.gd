extends Node

const SCN_STG 	= 0 	# Stage
const SCN_TEST 	= 1	    # Level Test
const SCN_LVL1 	= 2  	# Level 1

var pre_player = preload("res://Scenes/Player.tscn")
var form_setup: Node2D
var stage: Node2D
var cur_level: Node2D = null
var scenes = [
	"res://Scenes/Level_test.tscn",
	"res://Scenes/Network_setup.tscn",
]

func _ready():
	print("[Globals] Here will be placed global 'vars' and 'funcs'")

# Loads a Scene
func load_scene( ID ):
	print("[Globals] Loading Scene " + str( ID ) + " [ " + str( self.scenes[ID] ) + " ]")
	get_tree().change_scene( self.scenes[ID] )

# Adding player
func add_player( context,  id, name ):
	var position = Vector2(rand_range(100, 150), rand_range(100, 300))
	var new_player = pre_player.instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id)
	new_player.player_name = name
	new_player._id = str(id)
	new_player.global_position = position

	context.add_child(new_player)
	return new_player
