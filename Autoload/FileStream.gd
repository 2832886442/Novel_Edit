extends Node

const FILE_EXTENSION = ".md"
const BASE_SAVE_DIR = "user://novels"

# 对应 StatusManager.STATUS 的文件夹名（顺序必须一致！）
const SAVE_TYPE: Array[String] = ["/Note", "/Creation", "/Character"]

func _ready():
	# 预先创建所有分类目录（可选，也可以按需创建）
	for folder in SAVE_TYPE:
		ensure_directory_exists(BASE_SAVE_DIR + folder)

# 确保目录存在（支持绝对路径）
func ensure_directory_exists(dir_path: String) -> void:
	var err = DirAccess.make_dir_recursive_absolute(dir_path)
	if err != OK:
		push_error("FileStream: 无法创建目录 '%s'，错误: %s" % [dir_path, error_string(err)])

# 获取当前状态对应的完整保存路径（带子目录）
func _get_current_save_dir() -> String:
	# 从 StatusManager 获取当前状态索引
	var status_index = StatusManager.current_status
	
	# 安全检查：防止越界
	if status_index < 0 or status_index >= SAVE_TYPE.size():
		push_error("FileStream: current_status 超出范围: %d" % status_index)
		return BASE_SAVE_DIR  # 回退到根目录
	
	return BASE_SAVE_DIR + SAVE_TYPE[status_index]

# 保存内容到文件（自动根据 StatusManager.current_status 选择子目录）
func save_file(file_name: String, content: String) -> bool:
	if file_name.is_empty():
		push_error("FileStream: 文件名不能为空")
		return false

	var safe_name = sanitize_filename(file_name)
	var dir_path = _get_current_save_dir()
	var path = dir_path.path_join(safe_name + FILE_EXTENSION)

	# 确保目标子目录存在（双重保险）
	ensure_directory_exists(dir_path)

	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("FileStream: 无法创建文件 %s" % path)
		return false

	file.store_string(content)
	file.close()
	print("FileStream: 已保存文件 %s" % path)
	return true

# 检查是否存在指定名称的文件（在当前状态对应的目录中）
func file_exists(file_name: String) -> bool:
	if file_name.is_empty():
		return false
	var safe_name = sanitize_filename(file_name)
	var dir_path = _get_current_save_dir()
	var path = dir_path.path_join(safe_name + FILE_EXTENSION)
	return FileAccess.file_exists(path)

# 读取当前状态目录下的文件
func load_file(file_name: String) -> String:
	if not file_exists(file_name):
		return ""
	var safe_name = sanitize_filename(file_name)
	var dir_path = _get_current_save_dir()
	var path = dir_path.path_join(safe_name + FILE_EXTENSION)

	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	var content = file.get_as_text()
	file.close()
	return content

# 列出当前状态目录下的所有 .md 文件（不含扩展名）
func list_all_files() -> Array[String]:
	var dir_path = _get_current_save_dir()
	var files: Array[String] = []
	var dir = DirAccess.open(dir_path)
	if dir == null:
		return files

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(FILE_EXTENSION):
			files.append(file_name.trim_suffix(FILE_EXTENSION))
		file_name = dir.get_next()
	dir.list_dir_end()
	return files

# 清理文件名
func sanitize_filename(name: String) -> String:
	var invalid_chars = ["/", "\\", ":", "*", "?", "\"", "<", ">", "|", "\n", "\r"]
	var safe = name
	for c in invalid_chars:
		safe = safe.replace(c, "_")
	return safe.strip_edges()
