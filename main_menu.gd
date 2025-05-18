extends CanvasLayer

func _ready() -> void:
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://battle_scene.tscn") #Replace with file of the main game


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Not_Enough_Time_Game_Jam/TempFile") #Replace with file of the options


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Not_Enough_Time_Game_Jam/TempFile") #Replace with file of the credits


func _on_quit_pressed() -> void:
	get_tree().quit()
