extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -650

var motion = Vector2()
var on_ladder = false

onready var tween = $Tween

var player_name = ""

# controls de current animation
remote var animation = "stopped"
# controls de current mirroring
remote var flip = true

func _ready():
	$Sprite.flip_h = flip
	$PlayerName.text = player_name

# Sending my info to other players
remote func _set_position(pos):
	if !is_network_master():
		self.global_position = pos
	#global_transform.origin = pos
	# Updates the position ( interpolate avoid lags )

	#tween.interpolate_property(self, "global_position", global_position, pos, 0.05)
	#tween.start()

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

	# Sending my info to other players
	rpc_unreliable("_set_position", self.global_position)
	rset_unreliable("animation", animation)
	rset_unreliable("flip", flip)
