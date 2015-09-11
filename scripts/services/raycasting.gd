#Bresenham's line algorithm
func cast(x0, y0, x1, y1):
    var steep = abs(y1 - y0) > abs(x1 - x0)
    var tmp
    var reverse = false
    var line = []
    var ystep = 1

    if steep:
        tmp = x0; x0 = y0; y0 = tmp
        tmp = x1; x1 = y1; y1 = tmp

    if x0 > x1:
        tmp = x0; x0 = x1; x1 = tmp
        tmp = y0; y0 = y1; y1 = tmp
        reverse = true

    if y0 < y1:
        ystep = 1
    else:
        ystep = -1

    var deltax = x1 - x0
    var deltay = abs(y1 - y0)
    var error = -deltax / 2
    var y = y0
    var x

    for x in range(x0, x1 + 1):
        if steep:
            line.append(Vector2(y, x))
        else:
            line.append(Vector2(x, y))

        error = error + deltay
        if error >= 0:
            y = y + ystep
            error = error - deltax

    if (reverse):
        line.invert()

    return line

func check_visibility(unit_position, tiles, cost_map, tiles_range):
    var line = []
    var checked_tiles = {}
    var previous_tile
    var distance
    for tile in tiles:
        line = self.cast(unit_position.x, unit_position.y, tile.x, tile.y)
        if line != null && line.size():
            previous_tile = null
            distance = 0;
            for point in line:
                #setting start position
                if previous_tile == null:
                    previous_tile = point
                else:
                    if !cost_map.has(point):
                        break;

                    distance = distance  + self.calculate_tile_distance(previous_tile, point)
                    if distance > tiles_range:
                        break;


                    if checked_tiles.has(point):
                        checked_tiles[point] = min(checked_tiles[point], distance)
                    else:
                        checked_tiles[point] = distance

                    if !cost_map[point].walkable:
                        break;

                previous_tile = point

    return checked_tiles

func calculate_tile_distance(pos1, pos2):
    return  abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)



