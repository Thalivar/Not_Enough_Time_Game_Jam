extends Node2D

@export var player_group : Node2D  # Reference to the parent node containing player characters
@export var enemy_group : Node2D # Reference to the parent node containing enemy characters
@export var timeline : HBoxContainer  # UI container for displaying the timeline slots
@export var options : VBoxContainer
@export var enemy_button : PackedScene

var sorted_array = []  # Stores sorted timeline entries (players + their time values)
var players : Array[Character]  # Array of all player characters in the scene
var enemies : Array[Character] # Array of all enemy characters in the scene

func _ready():
	# Initialize player array
	for player in player_group.get_children():
		players.append(player.character)  # Add characters to array
		
	# Initialize enemy array
	for enemy in enemy_group.get_children():
		enemies.append(enemy.character) # add enemies to array
		
		var button = enemy_button.instantiate()
		button.character = enemy.character
		%EnemySelection.add_child(button)
	
	sort_and_display()  # Initial timeline render
	
	# Connect event bus signal
	EventBus.next_attack.connect(next_attack)
	
	# Start first attack (remove if auto-start not desired)
	next_attack()

func sort_combined_queue():
	sorted_array = []  # Clear previous entries
	
	# Combine all players' time queues into a single array
	for player in players:
		for time in player.queue:
			# Store each time entry with its associated character
			sorted_array.append({"character": player, "time": time})
		
	for enemy in enemies:
		for time in enemy.queue:
			sorted_array.append({"character": enemy, "time": time})
	
	# Sort the combined array by time (ascending order)
	sorted_array.sort_custom(sort_by_time)
	

# Custom sorting function: compares two entries by their "time" value
func sort_by_time(a, b):
	return a["time"] < b["time"]

func update_timeline():
	# Exit if no entries exist (safety check)
	if sorted_array.size() == 0:
		return
	
	# Safe check for timeline
	if timeline == null or not is_instance_valid(timeline):
		print("Timeline is null or invalid. Skipping update.")
		return
		
	# Safe check for timeline children
	if timeline.get_child_count() == 0:
		print("Timeline has no slots. Skipping update.")
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
	update_timeline()
	if sorted_array[0]["character"] in players:
		show_options()

# Process the current attack and update timeline
func pop_out():
	sorted_array[0]["character"].pop_out()  # Remove completed turn
	sort_and_display()                      # Re-sort timeline

# Execute attack for the current character
func attack():
	sorted_array[0]["character"].attack(get_tree())

# Attack sequence handler (connected to EventBus)
func next_attack():
	if sorted_array[0]["character"] in players:
		return
	attack()   # Execute attack
	pop_out()  # Update queue
	
func show_options():
	options.show()
	options.get_child(0).grab_focus()

func choose_enemy():
	%EnemySelection.show()
	%EnemySelection.get_child(0).grab_focus()
	
