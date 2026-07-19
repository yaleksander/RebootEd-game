extends Control

const menu_music = preload("res://sounds/Menu - ShuttedDown - Loop.ogg")

@onready var options_menu = $OptionsMenu
@onready var button_container = $VBoxContainer
@onready var game_title_sprite = $RebootedLogo 
@onready var transition_rect = $TransitionRect
@onready var music_player = $MenuMusic

const GAME_SCENE_PATH = "res://scenes/first_scene.tscn"

func _ready():
	music_player.stream = menu_music
	music_player.volume_db = -10
	music_player.play()
	
	if options_menu:
		options_menu.visible = false
	
	if game_title_sprite:
		game_title_sprite.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(game_title_sprite, "modulate:a", 1.0, 4.0)
	
	if transition_rect:
		transition_rect.visible = true
		var material = transition_rect.material as ShaderMaterial
		if material:
			material.set_shader_parameter("progress", 0.0)

func _on_start_button_pressed():
	if transition_rect:
		var material = transition_rect.material as ShaderMaterial
		if material:
			var tween = create_tween()
			tween.tween_property(material, "shader_parameter/progress", 1.0, 1.5)
			tween.tween_callback(func(): get_tree().change_scene_to_file(GAME_SCENE_PATH))
	else:
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
