var filePath = null
var file = File.new()


func _init(_filePath):
	filePath = _filePath
	if !file.file_exists(filePath):
		setFileData({})


func readValue(key):
	var data = getFileData()
	if data.has(key):
		return data[key]
		
	return null
	
	
func writeValue(key, value):
	var data = getFileData()
	data[key] = value
	setFileData(data)
	
	
func getFileData():
	if file.file_exists(filePath):
		file.open(filePath, File.READ)
		var data = file.get_var()
		file.close()
		return data
		
	return {}
	
	
func setFileData(data):
	file.open(filePath, File.WRITE)
	file.store_var(data)
	file.close()
