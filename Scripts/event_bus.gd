extends Node2D

signal next_attack  # Used to coordinate turn progression
signal character_health_changed(character)  # Emitted when a character's health changes
signal character_time_force_changed(character)  # Emitted when a character's time force changes
signal character_died(character)  # Emitted when a character's health reaches zero
