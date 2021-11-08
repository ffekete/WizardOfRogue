extends Area2D

var main = load("res://Scenes/Game/Main.tscn")
var explode = load("res://Scenes/Game/Explode.tscn")

var speed
var direction
var started

func set_speed(val):
	speed = val
	
func set_direction(val):
	direction = Vector2(val.x, val.y)
	
func set_position(val):
	position = Vector2(val.x, val.y)

func _ready():
	started = false

func _process(delta):
	if(started):
		position.x += direction.x * delta * speed
		position.y += direction.y * delta * speed

func start():
	started = true

func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	var e = explode.instance()
	e.position = position
	e.rotation_degrees = rotation_degrees
	get_parent().add_child(e)
	self.queue_free()
