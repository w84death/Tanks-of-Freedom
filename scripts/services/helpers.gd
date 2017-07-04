func array_diff(array_one, array_two):
    var values = Array(array_one)
    for val in array_two:
        values.erase(val)

    return values

func comp_days(date1, date2):
    return self.comp_dates(date1, date2, ['month', 'day'])

func comp_dates(date1, date2, params=['year', 'month', 'day']):
    var result = 0

    for param in params:
        result = comp(date1[param], date2[param])
        if result != 0:
            return result

func comp(a, b):
    return clamp(a - b , -1, 1)

func array_last_element(array):
    var size = array.size()
    if size == 0:
        return null

    return array[size - 1]
