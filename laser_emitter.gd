extends StaticBody2D

@onready var line_2d = $Line2D
@onready var ray_cast_2d = $RayCast2D

@export var max_distance = 2000

var is_active = false

func _ready():
	line_2d.clear_points()
	ray_cast_2d.add_exception(self)

func player_interact():
	is_active = !is_active
	if not is_active:
		line_2d.clear_points()
		ray_cast_2d.enabled = false
	else:
		ray_cast_2d.enabled = true

func _physics_process(_delta):
	if is_active:
		_update_emitter_laser()

func _update_emitter_laser():
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO)
	
	ray_cast_2d.target_position = Vector2.RIGHT * max_distance
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		var hit_pos = ray_cast_2d.get_collision_point()
		var collider = ray_cast_2d.get_collider()
		
		line_2d.add_point(to_local(hit_pos))
		
		if collider and collider.has_method("receive_laser"):
			var global_dir = Vector2.RIGHT.rotated(global_rotation).normalized().round()
			collider.receive_laser(global_dir)
		else:
			if collider and collider.has_method("laser_hit_target"):
				collider.laser_hit_target()
	else:
		line_2d.add_point(ray_cast_2d.target_position)
