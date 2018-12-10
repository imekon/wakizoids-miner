extends Panel

onready var scanner = $Control

func _process(delta):
	if Input.is_action_just_pressed("short_range_scanner"):
		set_short_range_scanner()
		
	if Input.is_action_just_pressed("medium_range_scanner"):
		set_medium_range_scanner()
		
	if Input.is_action_just_pressed("long_range_scanner"):
		set_long_range_scanner()
		
	if Input.is_action_just_pressed("filter_aliens"):
		set_filter(Globals.FILTER_ALIENS)
		
	if Input.is_action_just_pressed("filter_fleet"):
		set_filter(Globals.FILTER_FLEET)
		
	if Input.is_action_just_pressed("filter_none"):
		set_filter(Globals.FILTER_NONE)
		
	if Input.is_action_just_pressed("filter_planets"):
		set_filter(Globals.FILTER_PLANETS)
		
	if Input.is_action_just_pressed("filter_rocks"):
		set_filter(Globals.FILTER_ROCKS)
		
	if Input.is_action_just_pressed("filter_stuff"):
		set_filter(Globals.FILTER_STUFF)
		
func set_filter(filter):
	scanner.filter = filter

func set_short_range_scanner():
	scanner.set_short_range_scan()
	
func set_medium_range_scanner():
	scanner.set_medium_range_scan()
	
func set_long_range_scanner():
	scanner.set_long_range_scan()
	