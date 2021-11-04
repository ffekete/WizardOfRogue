extends Camera2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Main/Player")
	position = Vector2(200, 120)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# position = player.position

