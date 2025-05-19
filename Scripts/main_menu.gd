extends CanvasLayer

func _ready() -> void:
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/battle_scene.tscn") #Replace with file of the main game


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options.tscn") 


func _on_credits_pressed() -> void: #placeholder scene for now
	get_tree().change_scene_to_file("res://Scenes/credits.tscn") 


func _on_quit_pressed() -> void:
	get_tree().quit()
