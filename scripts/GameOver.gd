extends PanelContainer

onready var text_label = $Panel/RichTextLabel

func _ready():
	if Globals.credits < 0:
		process_credit_loss()

func on_back_pressed():
	Globals.credits = 0
	Globals.khi = 0.0
	
	get_tree().change_scene("res://scenes/Welcome.tscn")

func process_credit_loss():
	text_label.add_text("...or your credit went below zero because you destroyed something precious!")