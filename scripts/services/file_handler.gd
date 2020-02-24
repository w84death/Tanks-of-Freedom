var file = File.new()

func read(path):
	self.__create_file_if_no_exists(path)
	file.open(path, File.READ)
	var data = file.get_var()
	file.close()

	return data

func write(path, data):
	file.open(path, File.WRITE)
	file.store_var(data)
	file.close()

func __create_file_if_no_exists(path):
	if !file.file_exists(path):
		self.write(path, {'is_ok' : 1})
		return false

	return true

func file_exists(path):
	return self.file.file_exists(path)
