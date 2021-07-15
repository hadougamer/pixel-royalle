extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -650

var motion = Vector2()
var on_ladder = false

onready var tween = $Tween

var player_name = ""
var _id = ""

# controls de current animation
remote var animation = "stopped"
# controls de current mirroring
remote var flip = true

func _ready():
	$Sprite.flip_h = flip
	$PlayerName.text = player_name

# Sending my info to other players
remote func _set_position(pos):
	global_position = pos

func _physics_process(delta):
	if is_network_master():
		motion.y += GRAVITY

		if Input.is_action_pressed("ui_left"):
			flip = false
			animation = "walking"
			motion.x = -SPEED
		elif  Input.is_action_pressed("ui_right"):
			flip = true
			animation = "walking"
			motion.x = SPEED
		elif Input.is_action_pressed("ui_up"):
			# Upp the ladder
			if on_ladder == true:
				animation = "walking"
				motion.y -= (GRAVITY + 5)
		else:
			animation = "stopped"
			motion.x = 0

		if is_on_floor():
			if Input.is_action_pressed("ui_jump"):
				motion.y = JUMP_HEIGHT

		# Local client controls only local player
		motion = move_and_slide(motion, UP)

	$Sprite.flip_h = flip
	$Sprite.play(animation)

	for peer_id in Network.players:
		if (str(peer_id) == str( self._id )):
			pass

		print('Peer ID : ' + str(peer_id))
		print('MY ID:' +  str( self._id ) )
			
		rpc_id(peer_id, '_set_position', self.global_position)
	
	"""
	if !get_tree().is_network_server():
		rpc_unreliable('_set_position', self.global_position)
		rset_unreliable('animation', animation)
		rset_unreliable('flip', flip)
	"""

