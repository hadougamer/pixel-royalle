extends Node

var ip_address = null
var net = null

const SERVER_PORT = 6969
const MAX_PLAYERS = 10

var players 	= {}
var self_data 	= { name = "", position = Vector2(100, 100) }
var level_added = false

func _ready():
	print("[Network] Manage all network peers and actions")
	self.ip_address = self.get_ip_address()
	self.net = NetworkedMultiplayerENet.new()

	# Signals
	get_tree().connect('connected_to_server', 		self, '_server_connected')
	get_tree().connect('network_peer_connected', 	self, '_peer_connected')
	get_tree().connect('network_peer_disconnected', self, '_peer_disconnected')

func _process(delta):
	pass
	#print( peers )

func create_server( nickname ):
	print("[ Network ] " + str( nickname )  + " wanna create a server.")

	if ! self.ip_address:
		print("[ Network ] [ create_server ] Invalid IP Address")
		return
		
	if ! self.net:
		print("[ Network ] [ create_server ] Invalid Network Object")
		return

	# Creates the server	
	net.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(net)

	self.self_data.name = nickname
	self.players[ get_tree().get_network_unique_id() ] = self_data

	# Show setup wait screen
	Globals.form_setup.form_hide()
	Globals.form_setup.wait_show()

func join_server( nickname, ip):
	print("[ Network ] " + str( nickname )  + " wanna join to server.")

	if ! ip:
		print("[ Network ] [ join_server ] Invalid IP Address")
		return
		
	if ! self.net:
		print("[ Network ] [ join_server ] Invalid Network Object")
		return

	net.create_client(ip, SERVER_PORT)
	get_tree().set_network_peer(net)

	# Saves the current nicname to data
	self_data.name = nickname

# Callbacks
func _server_connected():
	print("[ Network ] Server is connected")

	var _id = get_tree().get_network_unique_id()
	players[ _id ] = self_data

	rpc("_send_player_info", _id, self_data )
	

remote func _send_player_info( id, info ):
	print('Set player info: ' + str( id )  )

	if get_tree().is_network_server():
		for peer_id in self.players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	
	self.players[id] = info

	# Loads the game scene
	if !self.level_added:
		get_tree().change_scene('res://Scenes/Level_test.tscn')
		self.level_added = true

	# Add the player
	var peer_name = "P - " + info.name
	Globals.add_player( get_tree().get_root(),  id, peer_name )

func _peer_connected( id ):
	pass
	# Add the player
	"""
	if ! self.players.has( id ):
		self.players[id] = self_data
		Globals.add_player( get_tree().get_root(),  id, self_data.name )
		

	# Loads the game scene
	get_tree().change_scene('res://Scenes/Level_test.tscn')

	print( self.players.size() )

		
	print('[ Network ] Peer ' +  str(id) +  ' is connected')
	self.peers = get_tree().get_network_connected_peers()
	for peer_id in self.peers:
		print('PEER_ID ' + str(peer_id))
		print('[ Network ] Peer id ' + str( peer_id ) + ' is in the server.')
		rpc_id(peer_id, '_send_info', id, self_data)
	"""
	


func _peer_disconnected( id ):
	print("[ Network ] Peer " +  str(id) +  " is disconnected")
	self.players.erase(id)

"""
# Sends the infos to peers
remote func _send_info( peer_id, info ):
	print( "Sending info to peer" + str( peer_id ) )

	# Hide the forms
	
	if Globals.form_setup:
		Globals.form_setup.form_hide()
		Globals.form_setup.wait_hide()

	var pre_player = preload("res://Scenes/Player.tscn")
	var position = Vector2(rand_range(100, 150), rand_range(100, 300))
	var new_player = pre_player.instance()
	new_player.set_name(str(peer_id))
	new_player.set_network_master(peer_id)
	new_player.player_name = info.name
	new_player._id = str(peer_id)
	new_player.global_position = position
	
	#get_tree().get_root().get_node("Level").get_node("Players").add_child(new_player)
	get_tree().get_root().add_child(new_player)
"""

# Resolves IP Address
func get_ip_address():
	var result_ip = ""
	if OS.get_name() == 'Android':
		result_ip = IP.get_local_addresses()[0]
	else:
		result_ip = IP.get_local_addresses()[3]

	for ip in IP.get_local_addresses():
		if ip.begins_with('192.168.') and not ip.ends_with('.1'):
			result_ip = ip

	return result_ip
