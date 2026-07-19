extends StaticBody2D

@onready var line_2d = $Line2D
@onready var ray_cast_2d = $RayCast2D

@export var max_distance = 2000

var is_hit_this_frame = false
var last_incoming_dir = Vector2.ZERO

func _ready():
	line_2d.clear_points()
	ray_cast_2d.add_exception(self)

func player_interact():
	rotation_degrees += 90.0
	if rotation_degrees >= 360.0:
		rotation_degrees = 0.0

func _physics_process(_delta):
	if is_hit_this_frame:
		_update_reflected_laser()
		is_hit_this_frame = false
	else:
		line_2d.clear_points()

func receive_laser(incoming_direction: Vector2):
	is_hit_this_frame = true
	last_incoming_dir = incoming_direction.normalized().round()

func _update_reflected_laser():
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	
	var local_in_dir = last_incoming_dir.rotated(-global_rotation).normalized().round()
	
	var local_up = Vector2.UP
	var local_right = Vector2.RIGHT
	
	var local_out_dir = local_up
	if local_in_dir == -local_up:
		local_out_dir = local_right
	elif local_in_dir == -local_right:
		local_out_dir = local_up
	
	ray_cast_2d.target_position = local_out_dir * max_distance
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		var hit_pos = ray_cast_2d.get_collision_point()
		var collider = ray_cast_2d.get_collider()
		
		line_2d.add_point(to_local(hit_pos))
		
		if collider and collider.has_method("receive_laser"):
			var global_out_dir = local_out_dir.rotated(global_rotation).normalized().round()
			collider.receive_laser(global_out_dir)
		else:
			if collider and collider.has_method("laser_hit_target"):
				collider.laser_hit_target()
	else:
		line_2d.add_point(ray_cast_2d.target_position)
