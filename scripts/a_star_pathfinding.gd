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

func pathSearch(startTile, endTile):
	searched_children.append(startTile)
	path = [startTile, endTile]
	var finalPath = _pathSearch2(startTile, endTile)

	#removing start element
	return finalPath

func prepareCostMap(cost_map, units):
	notWalkable.clear()
	grid.clear()
	for pos in units:
		var unit_pos = units[pos].get_pos_map()
		cost_map[unit_pos.x][unit_pos.y] = 999

	for x in range(cost_map.size()):
		for y in range(cost_map[x].size()):
			if (cost_map[x][y] == 999):
				notWalkable.append(Vector2(x,y))

			grid[Vector2(x,y)] = tileObject.new(cost_map[x][y])
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
	var cost
	var walkable = true
   
	func _init(cost):
		if(cost == 999):
			self.walkable = false

		self.cost = cost

      

