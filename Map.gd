extends TileMap

var grid = []

onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	_randomize()

func _randomize():
	for i in range(0, 40):
		grid.append([])
		for j in range(0, 20):
			grid[i].append(rng.randi() % 2)
