extends Node2D

signal next_attack  # Used to coordinate turn progression
signal time_force_changed(character)  # Emitted when a character's time force changes
signal character_died(character)  # Emitted when a character dies
signal battle_ended(victory)  # Emitted when battle ends (true = victory, false = defeat)
