extends Node2D

onready var credits_label = $CanvasLayer/CreditsLabel
onready var fleet_label = $CanvasLayer/FleetLabel
onready var rocks_label = $CanvasLayer/RocksLabel
onready var energy_label = $CanvasLayer/EnergyLabel
onready var shields_label = $CanvasLayer/ShieldsLabel
onready var khi_label = $CanvasLayer/KhiLabel

onready var player = $Player
onready var jump_panel = $CanvasLayer/JumpPanel
onready var trading_panel = $CanvasLayer/TradingPanel
onready var destination_list = $CanvasLayer/JumpPanel/DestinationList
onready var message_label = $CanvasLayer/MessageLabel
onready var message_tween = $CanvasLayer/MessageLabel/Tween

onready var Alien1 = load("res://scenes/Alien1.tscn")
onready var Alien2 = load("res://scenes/Alien2.tscn")
onready var Alien3 = load("res://scenes/Alien3.tscn")
onready var Alien4 = load("res://scenes/Alien4.tscn")

onready var Planet1 = load("res://scenes/Planet1.tscn")
onready var Planet2 = load("res://scenes/Planet2.tscn")
onready var Planet3 = load("res://scenes/Planet3.tscn")
onready var Planet4 = load("res://scenes/Planet4.tscn")

onready var Rock1 = load("res://scenes/Rock1.tscn")
onready var Rock2 = load("res://scenes/Rock2.tscn")
onready var Rock3 = load("res://scenes/Rock3.tscn")
onready var Rock4 = load("res://scenes/Rock4.tscn")
onready var Rock5 = load("res://scenes/Rock5.tscn")
onready var Rock6 = load("res://scenes/Rock6.tscn")

onready var MiningShip = load("res://scenes/MiningShip.tscn")

onready var Cat = load("res://scenes/Cat.tscn")
onready var Dog = load("res://scenes/Dog.tscn")
onready var XmasPudding = load("res://scenes/Pudding.tscn")
onready var Diversity = load("res://scenes/Diversity.tscn")
onready var BlackHole = load("res://scenes/BlackHole.tscn")

var jump_visible = false
var trading_visible = false
var jump_start
var trading_start
var mining_ship_id = 1

func _ready():
	randomize()
	
	show_message("Welcome to WakiZoids: Miner!")
	
	jump_start = jump_panel.rect_position
	trading_start = trading_panel.rect_position
	
	generate_rocks(30)
	generate_alien_swarm()
	generate_mining_ships()
	generate_planets()
	generate_stuff()
	
func show_message(text):
	message_label.text = text
	message_tween.interpolate_method(self, "on_message_tween", 1, 0, 5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	message_tween.start()
	
func on_message_tween(value):
	message_label.modulate.a = value

func _physics_process(delta):
	credits_label.text = "Credits: %d" % Globals.credits
	fleet_label.text = "Fleet: %d" % get_tree().get_nodes_in_group("mining_ship").size()
	var rock_count = get_tree().get_nodes_in_group("rocks").size()
	rocks_label.text = "Rocks: %d" % rock_count
	shields_label.text = "Shields: %d" % player.shields
	energy_label.text = "Energy: %3.0f" % player.energy
	khi_label.text = "Khi: %1.2f" % Globals.khi
	
	if rock_count < 10:
		generate_rocks(20)

	if Input.is_action_just_pressed("ui_jump"):
		process_jump()
		
	if Input.is_action_just_pressed("ui_trading"):
		process_trading()

func process_jump():
	jump_visible = !jump_visible
	if jump_visible:
		refresh_jump_locations()
		jump_panel.rect_position = Vector2(jump_start.x, jump_start.y - 410)
	else:
		jump_panel.rect_position = jump_start
		
func process_trading():
	trading_visible = !trading_visible
	if trading_visible:
		trading_panel.rect_position = Vector2(trading_start.x, trading_start.y - 410)
	else:
		trading_panel.rect_position = trading_start
		
func refresh_jump_locations():
	destination_list.clear()
	
	destination_list.add_item("Random location")
	
	var index = 1
	var i = 1

	var mining_ships = get_tree().get_nodes_in_group("mining_ship")
	for ship in mining_ships:
		destination_list.add_item("Mining Ship " + str(index))
		destination_list.set_item_metadata(i, ship)
		# print("mining ship: %d, %d" % [ship.global_position.x, ship.global_position.y])
		index += 1
		i += 1

	index = 1
	var planets = get_tree().get_nodes_in_group("planet")
	for planet in planets:
		destination_list.add_item(str(index) + " " + planet.planet_name)
		destination_list.set_item_metadata(i, planet)
		# print("planet: %d, %d" % [planet.global_position.x, planet.global_position.y])
		index += 1
		i += 1

func generate_mining_ships():
	for i in range(2):
		generate_mining_ship(Globals.random_range(65536), Globals.random_range(65536), mining_ship_id)
		mining_ship_id += 1
		
func generate_mining_ship(x: int, y: int, id: int):
	var p = MiningShip.instance()
	add_child(p)
	p.id = id
	p.position = Vector2(x, y)
	p.connect("mining_ship_killed", self, "on_mining_ship_killed")
	return p
	
func generate_planets():
	generate_planet(Planet1, Globals.random_range(65536), Globals.random_range(65536))
	generate_planet(Planet2, Globals.random_range(65536), Globals.random_range(65536))
	generate_planet(Planet3, Globals.random_range(65536), Globals.random_range(65536))
	generate_planet(Planet4, Globals.random_range(65536), Globals.random_range(65536))
	
func generate_rocks(count):
	for i in range(count):
		generate_rock(Rock1, Globals.random_range(65536), Globals.random_range(65536))
		generate_rock(Rock2, Globals.random_range(65536), Globals.random_range(65536))
		generate_rock(Rock3, Globals.random_range(65536), Globals.random_range(65536))
		generate_rock(Rock4, Globals.random_range(65536), Globals.random_range(65536))
		generate_rock(Rock5, Globals.random_range(65536), Globals.random_range(65536))
		generate_rock(Rock6, Globals.random_range(65536), Globals.random_range(65536))
	
func generate_planet(planet, x: int, y: int):
	return generate_something(planet, x, y)
	
func generate_rock(rock, x: int, y: int):
	return generate_something(rock, x, y)
	
func generate_stuff():
	generate_something(Cat, Globals.random_range(65536), Globals.random_range(65536))
	generate_something(Dog, Globals.random_range(65536), Globals.random_range(65536))
	generate_something(XmasPudding, Globals.random_range(65536), Globals.random_range(65536))
	generate_something(Diversity, Globals.random_range(65536), Globals.random_range(65536))
	generate_something(BlackHole, Globals.random_range(65536), Globals.random_range(65536))
	
func generate_something(something, x, y):
	var p = something.instance()
	add_child(p)
	p.position = Vector2(x, y)
	return p

func generate_alien_swarm():
	for i in range(20):
		generate_alien_ship(Alien1, Globals.random_range(65536), Globals.random_range(65536))
		generate_alien_ship(Alien2, Globals.random_range(65536), Globals.random_range(65536))
		generate_alien_ship(Alien3, Globals.random_range(65536), Globals.random_range(65536))
		generate_alien_ship(Alien4, Globals.random_range(65536), Globals.random_range(65536))
		
func generate_alien_ship(alien, x : int, y : int):
	var ship = alien.instance()
	add_child(ship)
	ship.position = Vector2(x, y)
	return ship

func on_player_dead():
	get_tree().change_scene("res://scenes/GameOver.tscn")
	
func on_mining_ship_killed():
	show_message("Mining Ship destroyed!")
	
func on_jump_pressed():
	if !destination_list.is_anything_selected():
		return
		
	var selected = destination_list.get_selected_items()
	if selected.size() != 1:
		return
		
	var index = selected[0]
	
	var item = destination_list.get_item_metadata(index)
	
	if item != null:
		jump_item(item)
	else:
		jump_anywhere()
		
	process_jump()

func jump_item(item):
	if player.energy < 300:
		show_message("Insufficient energy for jump")
		return
		
	var position = item.global_position
	position.x += Globals.random_range(1000)
	position.y += Globals.random_range(1000)
	player.global_position = position
	player.energy -= 300
	
func jump_anywhere():
	if player.energy < 300:
		show_message("Insufficient energy for jump")
		return

	var position = Vector2(Globals.random_range(65536), Globals.random_range(65536))
	player.global_position = position
	player.energy -= 300

func on_ship_pressed():
	if Globals.credits > 1000:
		process_buy_ship()
	else:
		show_message("Insufficient credit to buy mining ship")
		
	process_trading()

func process_buy_ship():
	generate_mining_ship(Globals.random_range(65536), Globals.random_range(65536), mining_ship_id)
	mining_ship_id += 1
	Globals.credits -= 1000
	