extends Button

@export var character : Character:
	set(value):
		character = value
		text = value.title

func _on_pressed() -> void:
	# Deal random damage between 10-25
	var damage = randi_range(10, 25)
	character.take_damage(damage)
	
	# Hide enemy selection UI
	get_parent().hide()
	
	# Continue battle sequence
	get_parent().owner.attack()
	get_parent().owner.pop_out()
