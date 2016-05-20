var grid = {}
var start_tile
var end_tile
var prev
var path

#var possible_neighbours = Vector2Array([Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1), Vector2(0,-1), Vector2(0,0), Vector2(0,1),Vector2(1,-1), Vector2(1,0), Vector2(1,1)])
var possible_neighbours = Vector2Array([Vector2(-1,0), Vector2(0,-1), Vector2(0,1), Vector2(1,0)])

func set_cost_grid(cost_grid):
    grid = cost_grid

func path_search(start, goal):
    var closed_set = Vector2Array()    #The set of nodes already evaluated.
    var open_set = []   #The set of tentative nodes to be evaluated, initially containing the start node
    open_set.append(start)
    var current
    var came_from = {}  # The map of navigated nodes.
    var tentative_g_score

    grid[start].G = int(0)    # Cost from start along best known path.
    # Estimated total cost from start to goal through y.
    grid[start].F = int(grid[start].G + self.get_manhattan(start, goal))

    while open_set.size() > 0:
        current = self.__smallestF(open_set)
        if current == goal:
            return self.__reconstruct_path(came_from, goal)

        open_set.remove(open_set.find(current))
        closed_set.push_back(current)
        for neighbor in self.__get_adjacent_tiles(current):
            if neighbor in closed_set:
                continue

            tentative_g_score = grid[current].G + 1

            if !(neighbor in open_set) or tentative_g_score < grid[neighbor].G :
                came_from[neighbor] = current
                grid[neighbor].G = tentative_g_score
                grid[neighbor].F = grid[neighbor].G + get_manhattan(neighbor, goal)
                if !(neighbor in open_set):
                    open_set.append(neighbor)
    return {}

func get_manhattan(start, end):
    return abs(start.x - end.x) + abs(start.y - end.y)

# find the tile with the smallest F value that is open
func __smallestF(open_set):
    var smallest = open_set[0]
    for t in open_set:
        if grid[t].F < grid[smallest].F:
            smallest = t
    return smallest

# create the path based
func __reconstruct_path(came_from, current_node):
    if current_node in came_from:
        var p = __reconstruct_path(came_from, came_from[current_node])
        p.append(current_node)
        return p
    else:
        return [current_node]

func __get_adjacent_tiles(center_tile):
    var result = Vector2Array()
    var vector
    for mod in self.possible_neighbours:
        vector = center_tile + mod
        if grid.has(vector) and grid[vector].walkable == true:
            result.push_back(vector)
    return result