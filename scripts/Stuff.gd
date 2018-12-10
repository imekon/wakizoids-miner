extends RigidBody2D

export var collection_credits = 500
export var shooting_debits = 1000

onready var label_node = $Node2D

func on_body_entered(body):
	if body.is_in_group("player"):
		Globals.credits += collection_credits
		
	if body.is_in_group("bullet"):
		Globals.credits -= shooting_debits
		
	queue_free()

func _process(delta):
	label_node.rotation = 0