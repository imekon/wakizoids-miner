extends KinematicBody2D

onready var label_node = $Node2D
onready var label = $Node2D/Label

var id setget set_id

func _process(delta):
	label_node.global_rotation = 0
	
func set_id(value):
	label.text = "Mining Ship: %d" % value