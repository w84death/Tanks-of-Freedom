const PATH = 'res://logs/log.txt'

var file = File.new()

func _init():
    self.__create_file_if_no_exists()

func store(data):
    file.open(self.PATH, File.READ_WRITE)
    file.seek_end(0)
    var date = OS.get_datetime()
    var date_str = "[%02d-%02d-%02d %02d:%02d:%02d] " % [date['day'], date['month'], date['year'], date['hour'], date['minute'], date['second']]
    file.store_line(date_str + data)
    file.close()

func file_exists(path):
    return self.file.file_exists(path)

func __create_file_if_no_exists():
    if !file.file_exists(self.PATH):
        file.open(self.PATH, File.WRITE)
        file.close()