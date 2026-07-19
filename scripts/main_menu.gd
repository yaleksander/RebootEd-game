extends Control

@onready var options_menu = $OptionsMenu
@onready var button_container = $VBoxContainer
@onready var game_title_sprite = $RebootedLogo 

const GAME_SCENE_PATH = "res://scenes/first_scene.tscn"

func _ready():
	if options_menu:
		options_menu.visible = false
	
	if game_title_sprite:
		game_title_sprite.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(game_title_sprite, "modulate:a", 1.0, 4.0)

func _on_start_button_pressed():
	get_tree().change_scene_to_file(GAME_SCENE_PATH)

func _on_options_button_pressed():
	options_menu.visible = true
	button_container.visible = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	options_menu.visible = false
	button_container.visible = true

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_fullscreen_button_toggled(toggled_on):
	if toggled_on:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
