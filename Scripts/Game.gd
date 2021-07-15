extends Node2D

# Init the Game Interface
func _ready():
	print("*** [Game] Welcome to Pixel Royalle Beta ***")
	# Load current scene
	Globals.load_scene( Globals.SCN_TEST )
	
func _process(delta):
	pass
