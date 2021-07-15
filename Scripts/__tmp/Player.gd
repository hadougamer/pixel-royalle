extends KinematicBody2D

# Movement Settings
const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -650
var motion = Vector2()

# Collision Controls
var on_ladder = false

var player_name = ""
var _id = ""

# Annimation controls on master
var animation = "stopped" # clip name
var flip = true # mirror

# Annimation controls on puppets
puppet var puppet_animation = "stopped" # clip name
puppet var puppet_flip 		= true # mirror
puppet var puppet_position 	= self.global_position # position

func _ready():
	$Sprite.flip_h = flip
	$PlayerName.text = player_name

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

		# Set puppet variables
		rset("puppet_animation", animation)
		rset("puppet_flip", flip)
		rset_unreliable("puppet_position", self.global_position)
	else:
		# Puppet movement
		$Sprite.flip_h = puppet_flip
		$Sprite.play(puppet_animation)
		self.global_position = puppet_position

	# Updates the position into network player list
	if get_tree().is_network_server():
		pass
		#Network.update_position(int(name), position)

