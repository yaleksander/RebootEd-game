extends Node2D

const ambience_music = preload("res://sounds/Ambience - It looks like life - Loop.ogg")

@onready var ambience_player = $PlayerAmbience

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ambience_player.stream = ambience_music
	ambience_player.volume_db = -10
	ambience_player.play()
