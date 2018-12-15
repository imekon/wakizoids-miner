extends PanelContainer

onready var text_label = $Panel/RichTextLabel

func _ready():
	match Globals.killed_by:
		Globals.KILLED_BY.ALIENS:
			process_aliens()
		Globals.KILLED_BY.CREDIT:
			process_credit_loss()
		Globals.KILLED_BY.BLACK_HOLE:
			process_black_hole()

func on_back_pressed():
	Globals.credits = 0
	Globals.khi = 0.0
	
	get_tree().change_scene("res://scenes/Welcome.tscn")
	
func process_aliens():
	text_label.add_text("You kept killing aliens or their scared rock!")

func process_credit_loss():
	text_label.add_text("Your credit went below zero because you destroyed something precious!")
	
func process_black_hole():
	text_label.add_text("Your found the one black hole in the universe!")
	