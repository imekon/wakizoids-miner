extends Sprite

onready var label_node = $Node2D
onready var label = $Node2D/Label

var planet_name setget , get_planet_name

signal player_in_orbit

func _process(delta):
	label_node.rotation = 0.0

func on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_in_orbit")

func get_planet_name():
	return label.text