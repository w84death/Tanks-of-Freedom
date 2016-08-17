func array_diff(array_one, array_two):
    var values = []

    for val in array_one:
        if array_two.find(val) == -1:
            values.append(val)

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

