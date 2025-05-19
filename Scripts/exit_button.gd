extends Button

# Path to main-menu scene file 
const MAIN_MENU_SCENE := "res://Scenes/Main_Menu.tscn"

func _pressed() -> void:
	MusicManager.play_menu_music()
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
