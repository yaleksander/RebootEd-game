extends CharacterBody2D

@export var speed = 50
@export var move_distance = 16

var amount_moved = 0

func player_action(_player_node, direction):
	if (amount_moved == 0):
		velocity = Vector2(0, 0)
		if (direction == "down"):
			velocity.y = speed
		elif (direction == "left"):
			velocity.x = -speed
		elif (direction == "right"):
			velocity.x = speed
		elif (direction == "up"):
			velocity.y = -speed
		print("received!")

func snap_to_grid():
	position.x = round((position.x - 8) / 16) * 16 + 8
	position.y = round((position.y - 8) / 16) * 16 + 8

func _physics_process(_delta):
	if velocity != Vector2.ZERO:
		amount_moved += velocity.length() * _delta
		if (amount_moved >= move_distance):
			amount_moved = 0
		
		move_and_slide()
		
		# Check if blocked in the direction of velocity
		var blocked = false
		if velocity.x > 0 and is_on_wall():
			blocked = true
		elif velocity.x < 0 and is_on_wall():
			blocked = true
		elif velocity.y > 0 and is_on_floor():
			blocked = true
		elif velocity.y < 0 and is_on_ceiling():
			blocked = true
			
		if blocked:
			amount_moved = 0
			velocity = Vector2.ZERO
			snap_to_grid()
		elif (amount_moved == 0):
			velocity = Vector2(0, 0)
			snap_to_grid()
