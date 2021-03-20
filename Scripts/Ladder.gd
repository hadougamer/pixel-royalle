extends Node2D

func _ready():
	pass # Replace with function body.


func _on_LadderArea_body_entered(body):
	if body.is_in_group("player"):
		print("Player is on ladder")
		body.on_ladder = true

func _on_LadderArea_body_exited(body):
	if body.is_in_group("player"):
		print("Player is out of ladder")
		body.on_ladder = false
