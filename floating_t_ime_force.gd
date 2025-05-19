extends Node2D

@export var character: Character  # Reference to character resource
@export var bar_offset: Vector2 = Vector2(0, -30)  # Position offset above character

@onready var time_force_bar = $"Time Force"  # Reference to the time force progress bar

func _ready():
	if character:
		# Connect to character's signals
		character.timeforce_changed.connect(_on_timeforce_changed)
		# Initial setup
		time_force_bar.max_value = character.max_timeforce
		time_force_bar.value = character.current_timeforce

func _process(_delta):
	if character and character.node:
		# Keep bar positioned above character
		global_position = character.node.global_position + bar_offset

# Update bar when timeforce changes
func _on_timeforce_changed(current: float, max_value: float):
	time_force_bar.max_value = max_value
	time_force_bar.value = current
