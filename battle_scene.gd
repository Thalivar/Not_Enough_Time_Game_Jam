extends Node2D

@export var player_group : Node2D  # Reference to the parent node containing player characters
@export var timeline : HBoxContainer  # UI container for displaying the timeline slots

var sorted_array = []  # Stores sorted timeline entries (players + their time values)
var players : Array[Character]  # Array of all player characters in the scene

func _ready():
	# Initialize player array by scanning the player_group's children
	for player in player_group.get_children():
		if player is Sprite2D and player.get("character") != null:
			players.append(player.character)  # Add valid characters to the players array

			# Ensure each character's action queue is initialized
			if player.character.queue.size() == 0:
				player.character.queue_reset()  # Reset queue if empty

	sort_and_display()  # Sort and render the timeline

func sort_combined_queue():
	sorted_array = []  # Clear previous entries
	
	# Combine all players' time queues into a single array
	for player in players:
		for time in player.queue:
			# Store each time entry with its associated character
			sorted_array.append({"character": player, "time": time})
	
	# Sort the combined array by time (ascending order)
	sorted_array.sort_custom(sort_by_time)

# Custom sorting function: compares two entries by their "time" value
func sort_by_time(a, b):
	return a["time"] < b["time"]

func update_timeLine():
	# Exit if no entries exist (safety check)
	if sorted_array.size() == 0:
		return
	
	# Iterate through timeline UI slots and assign icons
	var index = 0
	for slot in timeline.get_children():
		if index >= sorted_array.size():
			break  # Stop if we've processed all timeline entries
		
		# Get the TextureRect child (where the icon is displayed)
		var texture_rect = slot.find_child("TextureRect")
		if texture_rect and sorted_array[index]['character'].icon:
			texture_rect.texture = sorted_array[index]['character'].icon  # Set icon
		
		index += 1

# Helper function to sort and refresh the timeline UI
func sort_and_display():
	sort_combined_queue()
	update_timeLine()
