extends Node

var net = null
var ip_address = null

const SERVER_PORT = 6969
const MAX_PLAYERS = 10

# Players control
var players = {}
var self_data = { name = "", position = Vector2(100, 100) }

func _ready():
	net = NetworkedMultiplayerENet.new()
	self.ip_address = self.get_ip_address()
	
	# Trigger to network callbacks
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func create_server( player_name ):
	if net and ip_address:
		net.create_server(SERVER_PORT, MAX_PLAYERS)
		get_tree().set_network_peer(net)
		
		#self_data.name = player_name
		#players[get_tree().get_network_unique_id()] = self_data

		print("Server created ...")

func connect_to_server( player_name, client_ip ):
	print("Connect to server...")

	if net and ip_address:
		self_data.name = player_name
		# Set a connection callback
		get_tree().connect("connected_to_server", self, "_connected_to_server")

		# Allow client to inform different ip
		if client_ip != ip_address:
			ip_address = client_ip
		
		net.create_client(ip_address, SERVER_PORT)
		get_tree().set_network_peer(net)

func _connected_to_server():
	print("Connected to server ")
	# Sending data to other peers
	var _id = get_tree().get_network_unique_id()
	players[ _id ] = self_data
	rpc("_send_player_info", _id, self_data )

func _player_connected(id):
	print("Player connected: " + str( id ) )

func _player_disconnected(id):
	print("Player disconnected: " + str( id ) )
	players.erase(id)

remote func _send_player_info( id, info ):
	print('Set player info: ' + str( id )  )
	print(  info  )
	if get_tree().is_network_server():
		for peer_id in self.players:
			print('Peer ID: ' + str(peer_id))
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	
	self.players[id] = info
	
	self._load_game()

	# Add the player
	Globals.add_player( info.name, id, info.position )
	print( self.players )

func _load_game():
	print("Loading the game ...")
	get_tree().change_scene("res://Scenes/Level01.tscn")
	Globals.cur_scene = get_tree().get_root()

# Resolves IP Address
func get_ip_address():
	var result_ip = ""
	if OS.get_name() == "Android":
		result_ip = IP.get_local_addresses()[0]
	else:
		result_ip = IP.get_local_addresses()[3]

	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			result_ip = ip

	return result_ip
