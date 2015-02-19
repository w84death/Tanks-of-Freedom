var tileSize = 40
var tileSizeVector = Vector2(tileSize,tileSize)
var gridWidth= 30; var gridHeight = 30
var grid = {}
var startTile
var endTile
var prev
var path
var searched_children = []

var openList = []
var closedList = []

const RANDOMNESS = 50

var lastCurrent

func pathSearch(startTile, endTile):
	searched_children.append(startTile)
	path = [startTile, endTile]
	var finalPath = _pathSearch2(startTile, endTile)

	#removing start element
	return finalPath

func set_cost_grid(cost_grid):
	grid = cost_grid

# new path search
func _pathSearch2(start, goal):
	var closedset = []    #The set of nodes already evaluated.
	var openset = []   #The set of tentative nodes to be evaluated, initially containing the start node
	openset.append(start)
	var came_from = {}  # The map of navigated nodes.

	grid[start].G = 0    # Cost from start along best known path.
	# Estimated total cost from start to goal through y.
	grid[start].F = grid[start].G + get_manhattan(start, goal)

	while openset.size() > 0:
		var current = smallestF(openset)
		if current == goal:
			return reconstruct_path(came_from, goal)

		openset.remove(openset.find(current))
		closedset.append(current)
		for neighbor in _identify_successors(current, start, goal):
			if neighbor in closedset:
				continue
			#var tentative_g_score = grid[current].G + 1
			var tentative_g_score = grid[current].G + grid[current].cost
			
			if !(neighbor in openset) or tentative_g_score < grid[neighbor].G :
				came_from[neighbor] = current
				grid[neighbor].G = tentative_g_score
				grid[neighbor].F = grid[neighbor].G + get_manhattan(neighbor, goal)
				if !(neighbor in openset):
					openset.append(neighbor)
					searched_children.append(neighbor)
	return {}

func _identify_successors(current, start, goal):
	var successors = []
	var neighbours = self.get_adjacent_tiles(current)
	var dx = clamp(goal.x - current.x, -1, 1)
	var dy = clamp(goal.y - current.y, -1, 1)

	for neighbor in neighbours:
		if clamp(neighbor.x - current.x, -1, 1) != -dx && clamp(neighbor.x - current.y, -1, 1) != -dy:
			successors.append(neighbor)

	if successors.size() == 0:
		successors = neighbours

	return successors

# find the tile with the smallest F value that is open
func smallestF(openSet):
	var smallest = openSet[0]
	for t in openSet:
		if grid[t].F < grid[smallest].F:
			smallest = t
	return smallest

# create the path based
func reconstruct_path(came_from, current_node):
	if current_node in came_from:
		var p = reconstruct_path(came_from, came_from[current_node])
		p.append(current_node)
		return p
	else:
		return [current_node]

func get_manhattan(start, end):
	return abs(start.x-end.x)+abs(start.y-end.y)

func get_dist(start, end):
	return sqrt(pow(start.x-end.x,2)+pow(start.y-end.y,2))

func get_adjacent_tiles(center_tile):
	var result = []
	for i in range(-1,2):
		for j in range(-1,2):
			if i == 0 or j == 0:
				var vector = Vector2(center_tile.x+i,center_tile.y+j)
				if grid.has(vector) and grid[vector].walkable == true:
					result.append(vector)
	return result