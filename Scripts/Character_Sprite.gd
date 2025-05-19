extends Sprite2D

@export var character : Character  # Reference to the Character resource

func _ready():
	if character:
		character.node = self  # Link this sprite to the character
		texture = character.texture  # Set sprite texture from Character resource
