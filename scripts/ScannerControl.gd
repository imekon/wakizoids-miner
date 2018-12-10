extends Control

const TRACKING_WIDTH = 135
const TRACKING_HEIGHT = 83

var trackingRange = 10000.0
var trackingRange2 = trackingRange / 2.0
var trackingRatio = TRACKING_HEIGHT / trackingRange
var filter

func set_short_range_scan():
	trackingRange = 10000.0
	trackingRange2 = trackingRange / 2.0
	trackingRatio = TRACKING_HEIGHT / trackingRange
	
func set_medium_range_scan():
	trackingRange = 25000.0
	trackingRange2 = trackingRange / 2.0
	trackingRatio = TRACKING_HEIGHT / trackingRange	
	
func set_long_range_scan():
	trackingRange = 65536.0
	trackingRange2 = trackingRange / 2.0
	trackingRatio = TRACKING_HEIGHT / trackingRange
	
func _ready():
	filter = Globals.FILTER_NONE

func _process(delta):
	update()
	
func _draw():
	# draw a dot to signify the player
	var rect = Rect2(TRACKING_WIDTH / 2, TRACKING_HEIGHT / 2, 4, 4)
	var colour = Color(1.0, 0.0, 0.0)
	draw_rect(rect, colour)

	# there's only one player but...
	var players = get_tree().get_nodes_in_group("player")
	var player = players[0]
	var playerPos = player.position
	
	var gray_colour = Color(0.3, 0.3, 0.3)
	
	if filter == Globals.FILTER_NONE or filter == Globals.FILTER_ROCKS:
		colour = Color(0.0, 1.0, 0.0)
	else:
		colour = gray_colour
		
	var rocks = get_tree().get_nodes_in_group("rocks")
	for rock in rocks:
		var pos = rock.global_position
		var dist = playerPos.distance_to(pos)
		if dist < trackingRange2:
			var x = (pos.x - playerPos.x) * trackingRatio + TRACKING_WIDTH / 2
			var y = (pos.y - playerPos.y) * trackingRatio + TRACKING_HEIGHT / 2
			rect = Rect2(x - 1, y - 1, 3, 3)
			draw_rect(rect, colour)
	
	# location of aliens
	if filter == Globals.FILTER_NONE or filter == Globals.FILTER_ALIENS:
		colour = Color(1.0, 1.0, 0.5)
	else:
		colour = gray_colour
		
	var aliens = get_tree().get_nodes_in_group("aliens")
	for alien in aliens:
		var pos = alien.global_position
		var dist = playerPos.distance_to(pos)
		if dist < trackingRange2:
			var x = (pos.x - playerPos.x) * trackingRatio + TRACKING_WIDTH / 2
			var y = (pos.y - playerPos.y) * trackingRatio + TRACKING_HEIGHT / 2
			rect = Rect2(x - 1, y - 1, 3, 3)
			draw_rect(rect, colour)
	
	# location of fleet
	if filter == Globals.FILTER_NONE or filter == Globals.FILTER_FLEET:
		colour = Color(1.0, 0.0, 1.0)
	else:
		colour = gray_colour
		
	var mining_ships = get_tree().get_nodes_in_group("mining_ship")
	for mining_ship in mining_ships:
		var pos = mining_ship.global_position
		var dist = playerPos.distance_to(pos)
		if dist < trackingRange2:
			var x = (pos.x - playerPos.x) * trackingRatio + TRACKING_WIDTH / 2
			var y = (pos.y - playerPos.y) * trackingRatio + TRACKING_HEIGHT / 2
			rect = Rect2(x - 1, y - 1, 3, 3)
			draw_rect(rect, colour)
	
	# location of planets
	if filter == Globals.FILTER_NONE or filter == Globals.FILTER_PLANETS:
		colour = Color(0.5, 0.5, 1.0)
	else:
		colour = gray_colour
		
	var planets = get_tree().get_nodes_in_group("planet")
	for planet in planets:
		var pos = planet.global_position
		var dist = playerPos.distance_to(pos)
		if dist < trackingRange2:
			var x = (pos.x - playerPos.x) * trackingRatio + TRACKING_WIDTH / 2
			var y = (pos.y - playerPos.y) * trackingRatio + TRACKING_HEIGHT / 2
			rect = Rect2(x - 1, y - 1, 3, 3)
			draw_rect(rect, colour)

	if filter == Globals.FILTER_NONE or filter == Globals.FILTER_STUFF:
		colour = Color(1, 0, 1)
	else:
		colour = gray_colour

	# location of stuff
	var stuff = get_tree().get_nodes_in_group("stuff")
	for thing in stuff:
		var pos = thing.global_position
		var dist = playerPos.distance_to(pos)
		if dist < trackingRange2:
			var x = (pos.x - playerPos.x) * trackingRatio + TRACKING_WIDTH / 2
			var y = (pos.y - playerPos.y) * trackingRatio + TRACKING_HEIGHT / 2
			rect = Rect2(x - 1, y - 1, 3, 3)
			draw_rect(rect, colour)
