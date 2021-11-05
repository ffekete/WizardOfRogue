extends Node

export (PackedScene) var CaveTile
export (PackedScene) var Player
export var maze_width = 12
export var maze_height = 6
export var _seed = 1000
export var walls_to_remove = 20

var grid = []
var generated_maze = []
var tile_size = Global.grid_size

onready var player = get_node("Player")
onready var rng = RandomNumberGenerator.new()

var cell_length = 2

enum Direction {
	N, S, E, W
}

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
	
func generate():
	
	# inint maze
	grid.append([])
	for i in range(0, maze_width):
		grid.append([])
		for j in range(0, maze_height):
			grid[i].append(0)
	
	generated_maze.append([])
	for i in range(0, maze_width * cell_length + 1):
		generated_maze.append([])
		for j in range(0, maze_height * cell_length + 1):
			generated_maze[i].append(0)
	
	randomize()
	
	seed(_seed)
	
	_randomize(0, 0)
	_randomize(maze_width,maze_height)

	display_debug()
	project_grid_to_generated_maze()
	remove_walls(walls_to_remove)
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
	

func project_grid_to_generated_maze():
	var last_i
	var last_j
	for i in range(maze_height):
		for j in range(maze_width):
			# north
			var x = j * cell_length
			var y = i * 2
			last_j = x
			
			if((grid[j][i] & 1) == 0):
				
				for k in range (0, cell_length):
					#set_wall(x + k, y)
					generated_maze[x+k][y] = 1
			else:
				#set_wall(x, y)
				generated_maze[x][y] = 1
		
		for j in range(maze_width):
			# west
			var x = j * cell_length
			var y = i * 2
			last_i = y
			last_j = x
			
			if((grid[j][i] & 8) == 0):
					generated_maze[x][y+1] = 1
			else:
				pass
		
	for j in range(0, x * 2):
		var y = maze_height * 2

		for k in range (0, cell_length):
			# set_wall(j + k, y)
			generated_maze[j+k][y] = 1
			
	for j in range(0, y * 2):
		var x = maze_width * 2
		# set_wall(x, j)
		generated_maze[x][j] = 1
	
func place_walls():
	var last_i
	var last_j
	for i in range(maze_width * 2 + 1):
		for j in range(maze_height * 2 + 1):
			if(generated_maze[i][j] == 1):
				set_wall(i, j)
		
	
		
func remove_walls(amount):
	var walls = Array()
	
	for g in range(0, amount):
		
		walls.clear()
		
		for i in range(1, maze_width * 2):
			for j in range(1, maze_height * 2):
				if(i > 0 && i < maze_width * 2 && generated_maze[i][j] == 1 && 
					(
						!(generated_maze[i-1][j] == 1 && generated_maze[i][j+1] == 1) &&
						!(generated_maze[i+1][j] == 1 && generated_maze[i][j+1] == 1) && 
						!(generated_maze[i-1][j] == 1 && generated_maze[i][j-1] == 1) &&
						!(generated_maze[i+1][j] == 1 && generated_maze[i][j-1] == 1)
					)):
					walls.append(Vector2(i,j))
		
		if(walls.size() > 0):
			# shuffle wall collections
			walls.shuffle()
			
			print("nr of walls ", walls.size())
			print("removing 1")
			
			var wall = walls.pop_front()
			generated_maze[wall.x][wall.y] = 0
		
		
	display_debug()
	
		
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
