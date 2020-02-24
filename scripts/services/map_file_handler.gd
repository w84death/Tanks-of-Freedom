extends "res://scripts/services/file_handler.gd"

var data = {}

const DEFAULT_THEME = 'summer'

func __get_file_path(file_name, is_remote):
	if is_remote:
		return "user://" + file_name + ".remote"
	else:
		return "user://" + file_name + ".map"

func load_data_from_file(file_name, is_remote=false):
	var file_path = self.__get_file_path(file_name, is_remote)

	if self.file.file_exists(file_path):
		self.file.open(file_path, File.READ)
		self.data =  file.get_var()
		print('ToF: map ' + file_path + ' loaded from file')
		file.close()
		return true
	else:
		print('ToF: map file ' + file_path + ' not exists!')
		return false

func write_as_plain_file(path, data):
	file.open(path, File.WRITE)
	file.store_line("var map_data = [")
	var cell_line
	var cell
	for cell in data['tiles']:
		cell_line = "'x': " + str(cell.x) + ", "
		cell_line += "'y': " + str(cell.y) + ", "
		cell_line += "'terrain': " + str(cell.terrain) + ", "
		cell_line += "'unit': " + str(cell.unit)
		file.store_line("	{" + cell_line + "},")
	file.store_line("]")
	file.close()

func get_theme():
	if self.data.has('themeVAR') && self.data['themeVAR'] != null:
		return self.data['themeVAR']

	return self.DEFAULT_THEME

func get_tiles():
	return self.data['tiles']


