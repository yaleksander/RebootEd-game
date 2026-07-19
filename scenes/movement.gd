extends CharacterBody2D

const audio_move1 = preload("res://sounds/move1 - start.ogg")
const audio_move2 = preload("res://sounds/move2 - loop.ogg")
const audio_move3 = preload("res://sounds/move3 - finish.ogg")

var was_moving = false
var player_direction = "down"
var _using_player_a = true
var _loop_active = false
var is_pushing = false

@export var speed = 100
@export var push_speed = 25
@export var _map : TileMapLayer
@export var crossfade_time = 0.05

@onready var _animated_sprite = $PlayerAnimatedSprite
@onready var _audio_player = $PlayerWalkSound
@onready var _loop_player_a = $PlayerWalkSound/LoopPlayerA
@onready var _loop_player_b = $PlayerWalkSound/LoopPlayerB
@onready var _loop_timer = Timer.new()
@onready var _interact_area = $Interact
@onready var _interact_down = $Interact/down
@onready var _interact_left = $Interact/left
@onready var _interact_right = $Interact/right
@onready var _interact_up = $Interact/up
@onready var flashlight = $LanternaPivot/PointLight2D

func _ready():
	_audio_player.volume_db = -4
	_loop_player_a.volume_db = -4
	_loop_player_b.volume_db = -4
	
	_audio_player.finished.connect(func(): _start_loop())
	_loop_timer.one_shot = true
	_loop_timer.timeout.connect(_on_loop_timer_timeout)
	add_child(_loop_timer)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	check_push(input_direction)
	if (Input.is_action_just_pressed("interact")):
		check_action()
	var current_speed = speed
	if is_pushing:
		current_speed = push_speed
	velocity = input_direction * current_speed
	return input_direction

func animate(v):
	var card_dir = get_cardinal_direction(v)
	update_interact_area()
	if (card_dir != "none"):
		player_direction = card_dir
	_animated_sprite.play("walk " + player_direction)
	if (velocity.x == 0 && velocity.y == 0):
		_animated_sprite.stop()

func get_map_data():
	if not _map:
		return
		
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
	if _loop_active:
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

func get_cardinal_direction(v: Vector2) -> String:
	if (abs(v.x) > abs(v.y)):
		if (v.x < 0):
			return "left"
		else:
			return "right"
	elif (abs(v.x) < abs(v.y)):
		if (v.y < 0):
			return "up"
		else:
			return "down"
	return "none"

func update_interact_area():
	_interact_down.disabled = player_direction != "down"
	_interact_left.disabled = player_direction != "left"
	_interact_right.disabled = player_direction != "right"
	_interact_up.disabled = player_direction != "up"

func check_push(input_direction: Vector2):
	is_pushing = false
	if (input_direction == Vector2.ZERO):
		return

	var card_dir = get_cardinal_direction(input_direction)
	
	for body in _interact_area.get_overlapping_bodies():
		if (body.has_method("player_push")):
			var to_box = body.global_position - global_position
			var box_dir = get_cardinal_direction(to_box)
			
			if (box_dir == card_dir):
				is_pushing = true
				if (body.velocity == Vector2.ZERO):
					body.player_push(card_dir)

func check_action():
	for body in _interact_area.get_overlapping_bodies():
		if (body.has_method("player_interact")):
			body.player_interact()

func _physics_process(_delta):
	var v = get_input()
	get_map_data()
	move_and_slide()
	animate(v)
	walk_sound()
	
	if flashlight:
		# Força o nó a ficar estático no centro do Player
		flashlight.position = Vector2.ZERO
		
		# Calcula o ângulo exato para o mouse
		var angle = global_position.angle_to_point(get_global_mouse_position())
		flashlight.rotation = angle
		
		# Pega o tamanho da textura para calcular a metade dela automaticamente
		if flashlight.texture:
			var texture_width = flashlight.texture.get_size().x
			# Multiplica pela metade do tamanho real da imagem para jogar o pivô na ponta esquerda
			flashlight.offset = Vector2(texture_width / 2.0, 0)
