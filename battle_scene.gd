extends Node2D

@export var player_group : Node2D
@export var timeline : HBoxContainer

var sorted_array = []
var players : Array[Character]

func _ready():
	for player in player_group.get_children():
		players.append(player.character)
	
	sort_and_display()

func sort_combined_queue():
	var player_array = []
	for player in players:
		for i in player.queue:
			player_array.append({"character" : player, "time" : i})
	
	sorted_array = player_array
	player_array.sort_custom(sort_by_time)
	
func sort_by_time(a, b):
	return a["time"] < b["time"]

func update_timeline():
	var index : int = 0
	for slot in timeline.get_children():
		slot.find_child("TextureRect").texture = sorted_array[index]["character"].icon
		index += 1

func sort_and_display():
	sort_combined_queue()
	update_timeline()
