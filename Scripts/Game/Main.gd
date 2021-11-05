extends Node

export (PackedScene) var CaveTile
export (PackedScene) var Player

var grid = []
var tile_size = Global.grid_size

onready var player = get_node("Player")
onready var rng = RandomNumberGenerator.new()

var maze_width = 8
var maze_height = 8

var cell_length = 2

enum Direction {
	N, S, E, W
}

func getOpposite(direction) -> int:
	if(direction == Direction.N):
		return Direction.S
	if(direction == Direction.S):
		return Direction.N	
	if(direction == Direction.E):
		return Direction.W
	return Direction.E
	
func getDxDy(direction) -> Vector2:
	if(direction == Direction.N):
		return Vector2(0, -1)
	if(direction == Direction.S):
		return Vector2(0, 1)
	if(direction == Direction.E):
		return Vector2(1, 0)

	return Vector2(-1, 0)
	
func get_bit(direction):
	if(direction == Direction.N):
		return 1
	if(direction == Direction.S):
		return 2
	if(direction == Direction.E):
		return 4
	return 8

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_viewport().get_visible_rect().size)
	
	# inint maze
	grid.append([])
	for i in range(0, maze_width):
		grid.append([])
		for j in range(0, maze_height):
			grid[i].append(0)
	
	rng.randomize()
	
	seed(1000)
	
	_randomize(0, 0)
	_randomize(maze_width,maze_height)

	display_debug()
	
	place_walls()
				
	player.start(Vector2(16, 16))

var x = maze_width
var y = maze_height

func _randomize(cx, cy):
			
	var dir = Direction.values()
	dir.shuffle()
	
	for direction in dir:
		var nx = cx + getDxDy(direction).x
		var ny = cy + getDxDy(direction).y
		
		if(between(nx, x) && between(ny, y) && grid[nx][ny] == 0):
			grid[cx][cy] |= get_bit(direction)
			grid[nx][ny] |= get_bit(getOpposite(direction))
			
			_randomize(nx, ny)
		

func between(v, upper) -> bool:
	return (v >= 0) && (v < upper)

func set_wall(i, j):
	var tile = CaveTile.instance()
	tile.position.x = i * 16
	tile.position.y = j * 16
	add_child(tile)	
	
	
func place_walls():
	var last_i
	var last_j
	for i in range(maze_height):
		for j in range(maze_width):
			# north
			var x = i * cell_length
			var y = j * 2
			last_j = y
			if((grid[i][j] & 1) == 0):
				
				for k in range (0, cell_length):
					set_wall(x + k, y)
			else:
				set_wall(x, y)
				
		set_wall(i, last_j)
		
		for j in range(maze_width):
			# west
			var x = i * cell_length
			var y = j * 2
			last_i = x
			last_j = y
			if((grid[i][j] & 8) == 0):
					set_wall(x, y + 1)
				
			else:
				pass
		
	for j in range(0, x * 2):
		var y = maze_height * 2
		
		for k in range (0, cell_length):
			set_wall(j + k, y)
			
	for j in range(0, y * 2):
		var x = maze_width * 2
		set_wall(x, j)
	
		
func display_debug():
	for i in range(0, y):
		for j in range(0, x):
			if(grid[j][i] & 1 == 0):
				printraw("+---")
			else:
				printraw("+   ")
	
		print("+")
	
		for j in range(0, x):
			if(grid[j][i] & 8 == 0):
				printraw("|   ")
			else:
				printraw("    ")
				
		print("|")
	
	for i in range (0, x):
		printraw("+---")
	
	print("+")
