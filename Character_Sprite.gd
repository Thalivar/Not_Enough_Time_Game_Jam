extends Sprite2D

@export var character : Character

func _ready():
	if character:
		character.node = self
		texture = character.texture
