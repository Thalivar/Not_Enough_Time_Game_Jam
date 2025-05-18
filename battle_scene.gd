extends Node2D

@export var player_group : Node2D
@export var timeline : HBoxContainer

var sorted_array = []
var players : Array[Character]

func _ready():
	# Initialize player array
	for player in player_group.get_children():
		if player is Sprite2D and player.get("character") != null:
			players.append(player.character)
			
			# Ensure queue is initialized
			if player.character.queue.size() == 0:
				player.character.queue_reset()
	
	sort_and_display()

func sort_combined_queue():
	sorted_array = []
	
	# Create array of players and their times
	for player in players:
		for time in player.queue:
			sorted_array.append({"character": player, "time": time})
	
	# Sort the array by time
	sorted_array.sort_custom(sort_by_time)
	
func sort_by_time(a, b):
	return a["time"] < b["time"]

func update_timeline():
	# Safety check
	if sorted_array.size() == 0:
		return
		
	# Update timeline display
	var index = 0
	for slot in timeline.get_children():
		if index >= sorted_array.size():
			break
			
		var texture_rect = slot.find_child("TextureRect")
		if texture_rect and sorted_array[index]["character"].icon:
			texture_rect.texture = sorted_array[index]["character"].icon
		
		index += 1

func sort_and_display():
	sort_combined_queue()
	update_timeline()
