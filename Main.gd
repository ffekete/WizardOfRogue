extends Node

export (PackedScene) var CaveTile
export (PackedScene) var Player

var grid = []
var tile_size = Global.grid_size
var player

onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_viewport().get_visible_rect().size)
	rng.randomize()
	_randomize()
	player = get_node("Player")
	player.start(Vector2(0,0))

func _randomize():
	for i in range(0, 40):
		grid.append([])
		for j in range(0, 20):
			grid[i].append(rng.randi() % 2)
			if(grid[i][j] == 1):
				var tile = CaveTile.instance()
				tile.visible = true
				tile.position.x = i * 16
				tile.position.y = j * 16
				add_child(tile)
			
