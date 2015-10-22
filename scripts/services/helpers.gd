func array_diff(array_one, array_two):
    var values = []

    for val in array_one:
        if array_two.find(val) == -1:
            values.append(val)

    return values

