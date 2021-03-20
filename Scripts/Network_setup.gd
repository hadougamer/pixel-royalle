extends Node2D

var network = null
var ip_address = null

const SERVER_PORT = 6969
const MAX_PLAYERS = 10

func _ready():
	network = NetworkedMultiplayerENet.new()
	self.ip_address = self.get_ip_address()
	$Form/Fields/IP.text = self.ip_address
	# Trigger to network callbacks
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _on_Create_server_pressed():
	if network and ip_address:
		network.create_server(SERVER_PORT, MAX_PLAYERS)
		get_tree().set_network_peer(network)

		$Form.hide()
		
		print("Server created ...")


func _on_Join_server_pressed():
	if network and ip_address:
		# Allow client to inform different ip
		if $Form/Fields/IP.text != ip_address:
			ip_address = $Form/Fields/IP.text
		
		network.create_client(ip_address, SERVER_PORT)
		get_tree().set_network_peer(network)

		$Form.hide()

		print("Joined to server "  + str(ip_address) +  ":" + str(SERVER_PORT) + " ...")


func _player_connected(id):
	# Set player id
	#Globals.player2id=id
	Globals.enemies_ids.append(id)

	# load current level
	var level = preload("res://Scenes/Level01.tscn").instance()
	get_tree().get_root().add_child(level)

func get_ip_address():
	var ip_address = ""
	if OS.get_name() == "Android":
		ip_address = IP.get_local_addresses()[0]
	else:
		ip_address = IP.get_local_addresses()[3]

	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip

	return ip_address
