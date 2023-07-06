extends Node2D

@export var Card = preload("res://Scenes/card.tscn")

var pathAnimals = "res://Assets/animals/"
var Textures = []
var cards = []
var open_cards = []

var ROW = 4
var COL = 5

func _ready():
	Textures = get_animal_dir(pathAnimals)
	if Textures.size() > 0:
		Textures.shuffle()
		var randomTexture = Textures.slice(0, (ROW * COL)/2)
		
		for t in randomTexture:
			var card = Card.instantiate()
			card.get_node("Observe").texture = t
			cards.append(card)
			var card_match = Card.instantiate()
			card_match.get_node("Observe").texture = t
			cards.append(card_match)
			
	cards.shuffle()
	for row in ROW:
		for col in COL:
			var c = cards[col + row * COL]
			c.position = Vector2(32, 32) + Vector2( 64 * col, 64 * row)
			add_child(c)

func check():
	if  open_cards.size() >= 2:
		for card in cards:
			card.can_control = false
		
		if open_cards[0].get_node("Observe").texture == \
			open_cards[1].get_node("Observe").texture:
			await get_tree().create_timer(0.5).timeout
			for card in open_cards:
				card.queue_free()
				cards.erase(card)
			continue_control()

		else:
			await get_tree().create_timer(0.5).timeout
			for card in open_cards:
				card.get_node("AnimationPlayer").play("flip_back")
			continue_control()
			
func continue_control():
	for card in cards:
		card.can_control = true
	open_cards = []

	
func get_animal_dir(path: String):
	var files = []
	var directories = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with('.png'):
#				print("Found file: " + file_name)
				files.append(load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files
	
