var tileSize = 40
var tileSizeVector = Vector2(tileSize,tileSize)
var gridWidth= 20; var gridHeight = 15
var grid = {}
var startTile
var endTile
var prev
var path
var searched_children = []
var notWalkable = []

var openList = []
var closedList = []
var font = load("res://font.fnt")


var lastCurrent

func _ready():

var i = 0
var j = 0
for i in range(gridWidth):
	for j in range(gridHeight):
		# randomly make a tile notWalkable
		var tf
		if(randi()%100 > 25): #25% chance the tile is not walkable
			tf = true
		else:
			tf = false
			notWalkable.append(Vector2(i,j))
		grid[Vector2(i,j)] = tileObject.new(tf)


startTile = Vector2(round(gridWidth/4),gridHeight/2)
endTile = Vector2(round(gridWidth-4),gridHeight/2)

searched_children.append(startTile)


path = [startTile, endTile]
var finalPath = _pathSearch2(startTile, endTile)
if finalPath.size() > 0 : # if a path was found
	for fp in finalPath:
		closedList.append(fp) # colour the tiles
		path.append(fp) # draw the path on the tiles

# new path search
func _pathSearch2(start, goal):
print("start")
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
	for neighbor in get_adjacent_tiles(current):
		if neighbor in closedset:
			continue
		var tentative_g_score = grid[current].G + 1

		if !(neighbor in openset) or tentative_g_score < grid[neighbor].G :
		came_from[neighbor] = current
		grid[neighbor].G = tentative_g_score
		grid[neighbor].F = grid[neighbor].G + get_manhattan(neighbor, goal)
		if !(neighbor in openset):
		openset.append(neighbor)
		searched_children.append(neighbor)

return {}

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

func _pathSearch(start, end):

var adjacent_tiles
var lowest_f = 99999
var lowest_f_tile
var current_tile = startTile


for i in range(60):
	closedList.append(current_tile)
	adjacent_tiles = get_adjacent_tiles(current_tile)
	lowest_f = 99999
	for tile in adjacent_tiles:

		if !(tile in closedList):
		### Set parent to current tile ###
		grid[tile].parent = current_tile
		### Calculate g, h & f score ###
		grid[tile].G = grid[grid[tile].parent].G+1
		grid[tile].H = (get_manhattan(tile, endTile))
		grid[tile].F = (grid[tile].G+grid[tile].H)

		### Add tiles to open list ###
		openList.append(tile)
		searched_children.append(tile)

		### Find the lowest f score ###
		if grid[tile].F <= lowest_f:
			lowest_f = grid[tile].F
			lowest_f_tile = tile

current_tile = lowest_f_tile
lastCurrent = current_tile
if( grid[current_tile].H <= 0 ):
	break
update()

func get_manhattan(start, end):
#var distance = sqrt(pow(start.x-end.x,2)+pow(start.y-end.y,2))
var distance = abs(start.x-end.x)+abs(start.y-end.y)
return(distance)

func get_dist(start, end):
#var distance = sqrt(pow(start.x-end.x,2)+pow(start.y-end.y,2))
var distance = sqrt(pow(start.x-end.x,2)+pow(start.y-end.y,2))
return(distance)

func get_adjacent_tiles(center_tile):
var result = []
for i in range(-1,2):
	for j in range(-1,2):
		if i == 0 or j == 0:
			var vector = Vector2(center_tile.x+i,center_tile.y+j)
			if grid.has(vector) and grid[vector].walkable == true:
				result.append(vector)
return result


class tileObject:
	#Tile Object Class

	var parent
	var G = 0
	var H = 0
	var F = 0
	var color = Color(1,1,1)
	var walkable

	func _init(walkable):
	self.walkable = walkable

	if !self.walkable:
	color = Color(0,0,0)

func _draw():

###   DRAW TILES   ###
for tile in openList:
	draw_rect(Rect2(tile*tileSizeVector, tileSizeVector), Color(0.2,0.2,0.2))
	if grid[tile].parent != null:
		draw_line(tile*tileSizeVector+(tileSizeVector/2), grid[tile].parent*tileSizeVector+(tileSizeVector/2), Color(0,0,0), 2)

for tile in closedList:
	draw_rect(Rect2(Vector2(tile[0]*tileSize,tile[1]*tileSize), Vector2(tileSize,tileSize)), Color(0.7,0.2,0.2))


###   START & END TILES   ###
draw_rect(Rect2(startTile*Vector2(tileSize,tileSize), Vector2(tileSize,tileSize)), Color(0,0.7,0))
draw_rect(Rect2(endTile*Vector2(tileSize,tileSize), Vector2(tileSize,tileSize)), Color(1,0,0))

for tile in searched_children:
	draw_rect(Rect2(tile*Vector2(tileSize,tileSize), Vector2(tileSize,tileSize)), Color(1,1,1,0.25))

# paint not walkable tiles blue
for tile in notWalkable:
	draw_rect(Rect2(tile*Vector2(tileSize,tileSize), Vector2(tileSize,tileSize)), Color(0,0,1,0.25))

###   DRAW GRID   ###
for i in range(gridWidth):
	draw_line(Vector2(i*tileSize,0), Vector2(i*tileSize,tileSize*gridHeight), Color(0,0,0), 1 )
for i in range(gridHeight):
	draw_line(Vector2(0,i*tileSize), Vector2(tileSize*gridWidth,i*tileSize), Color(0,0,0), 1 )
	### DRAW PATH ###
var i = 0
for p in path:
	if i > 0:
		draw_line(prev*tileSizeVector+tileSizeVector/2, p*tileSizeVector+tileSizeVector/2, Color(0,0,0), 10)
	prev = p
	i += 1

for tile in grid:
	#draw_rect(Rect2(Vector2(tile[0]*tileSize,tile[1]*tileSize), Vector2(tileSize,tileSize)), grid[tile].color)
	if grid[tile].F > 0:
		draw_string(font, tile*tileSizeVector+Vector2(0,12), "F: "+str(round(grid[tile].F)))
		draw_string(font, tile*tileSizeVector+Vector2(0,24), "G: "+str(round(grid[tile].G)))
		draw_string(font, tile*tileSizeVector+Vector2(0,36), "H: "+str(round(grid[tile].H)))
      

