extends CharacterBody2D
const audio_move1 = preload("res://sounds/move1 - start.ogg")
const audio_move2 = preload("res://sounds/move2 - loop.ogg")
const audio_move3 = preload("res://sounds/move3 - finish.ogg")

var was_moving = false
var _using_player_a = true
var _loop_active = false

@export var speed = 200
@export var _map : TileMapLayer
@export var crossfade_time := 0.05  # segundos de sobreposição

@onready var _animated_sprite = $PlayerAnimatedSprite
@onready var _audio_player = $PlayerWalkSound
@onready var _loop_player_a = $PlayerWalkSound/LoopPlayerA
@onready var _loop_player_b = $PlayerWalkSound/LoopPlayerB
@onready var _loop_timer = Timer.new()

func _ready():
	_audio_player.finished.connect(func(): _start_loop())
	_loop_timer.one_shot = true
	_loop_timer.timeout.connect(_on_loop_timer_timeout)
	add_child(_loop_timer)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func animate():
	if (abs(velocity.x) > abs(velocity.y)):
		if (velocity.x < 0):
			_animated_sprite.play("walk left")
		else:
			_animated_sprite.play("walk right")
	elif (abs(velocity.x) < abs(velocity.y)):
		if (velocity.y < 0):
			_animated_sprite.play("walk up")
		else:
			_animated_sprite.play("walk down")
	else:
		_animated_sprite.stop()

func get_map_data():
	if (_map.get_cell_tile_data(_map.local_to_map(position)).get_custom_data("dirt")):
		velocity /= 2.0

func _start_loop():
	if (velocity.x != 0 || velocity.y != 0):
		_loop_active = true
		_using_player_a = true
		_play_loop_segment(_loop_player_a)

func _play_loop_segment(player: AudioStreamPlayer):
	player.stream = audio_move2
	player.play()
	var wait_time = audio_move2.get_length() - crossfade_time
	_loop_timer.wait_time = max(wait_time, 0.01)
	_loop_timer.start()

func _on_loop_timer_timeout():
	if not _loop_active or (velocity.x == 0 && velocity.y == 0):
		_loop_active = false
		return
	# alterna pro outro player, iniciando ANTES do atual terminar
	_using_player_a = !_using_player_a
	var next_player = _loop_player_a if _using_player_a else _loop_player_b
	_play_loop_segment(next_player)

func _stop_loop():
	_loop_active = false
	_loop_timer.stop()
	_loop_player_a.stop()
	_loop_player_b.stop()

func walk_sound():
	if (velocity.x != 0 || velocity.y != 0):
		if (!was_moving):
			_stop_loop()
			_audio_player.set_stream(audio_move1)
			_audio_player.play()
		was_moving = true
	elif (was_moving):
		_stop_loop()
		_audio_player.set_stream(audio_move3)
		_audio_player.play()
		was_moving = false

func _physics_process(_delta):
	get_input()
	get_map_data()
	animate()
	walk_sound()
	move_and_slide()
