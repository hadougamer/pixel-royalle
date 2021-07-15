extends Node2D

var _nickname = ""
var _ip = ""

func _ready():
	# Client can inform different ip
	$Form/Fields/IP.text = Network.ip_address
	_ip = $Form/Fields/IP.text

# Input the nickname
func _on_Nickname_text_changed( new_nickname ):
	_nickname = new_nickname

# Press CREATE server button
func _on_Create_server_pressed():
	if _nickname == "":
		return

	Network.create_server( _nickname )

	self._form_hide()
	self._wait_show()
	#self._load_game()

# Press JOIN server button
func _on_Join_server_pressed():
	if _nickname == "":
		return

	Network.connect_to_server( _nickname, _ip)
	
	#self._form_hide()

func _wait_show():
	$Wait/Fields/SERV_IP.text = self._ip
	$Wait.show()

func _form_hide():
	$Form.hide()
