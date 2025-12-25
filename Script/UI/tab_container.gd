extends TabContainer

@onready var note_btn: = %NoteBtn
@onready var creation_btn: = %CreationBtn
@onready var character_btn: = %CharacterBtn

@onready var note_gridContainer: GridContainer = $Note/ScrollContainer/GridContainer
@onready var creation_gridContainer: GridContainer = $Creation/ScrollContainer/GridContainer
@onready var character_gridContainer: GridContainer = $Character/ScrollContainer/GridContainer

const ADD_SOMTHING = preload("res://Scene/UI/model/add_something.tscn")
const BOOK = preload("res://Scene/UI/model/book.tscn")

func _ready() -> void:
	StatusManager.AddSomething.connect(add_something)
	
	note_btn.pressed.connect(note_btn_press)
	creation_btn.pressed.connect(creation_btn_press)
	character_btn.pressed.connect(character_btn_press)
	
	for node in get_children():
		if node.is_in_group("AddSomething"):
			node.cancel_btn.pressed.connect(goback_current_status)

	_load_books_for_status(StatusManager.STATUS.NOTE, note_gridContainer)
	_load_books_for_status(StatusManager.STATUS.CREATION, creation_gridContainer)
	_load_books_for_status(StatusManager.STATUS.CHARACTER, character_gridContainer)

func _process(delta: float) -> void:
	pass

func note_btn_press():
	self.current_tab = StatusManager.STATUS.NOTE
	StatusManager.emit_signal("StatusChange",self.current_tab)

func creation_btn_press():
	self.current_tab = StatusManager.STATUS.CREATION
	StatusManager.emit_signal("StatusChange",self.current_tab)

func character_btn_press():
	self.current_tab = StatusManager.STATUS.CHARACTER
	StatusManager.emit_signal("StatusChange",self.current_tab)

func add_something(status):
	print(status)
	match status:
		StatusManager.STATUS.NOTE:
			add_note()
		StatusManager.STATUS.CREATION:
			add_creation()
		StatusManager.STATUS.CHARACTER:
			add_character()

func add_note():
	self.current_tab = StatusManager.STATUS.ADD_NOTE
	
func add_creation():
	self.current_tab = StatusManager.STATUS.ADD_CREATION
	
func add_character():
	self.current_tab = StatusManager.STATUS.ADD_CHARACTER

func goback_current_status():
	self.current_tab = StatusManager.current_status
	var grid = get_child(self.current_tab).get_node("ScrollContainer/GridContainer")
	_load_books_for_status(StatusManager.current_status,grid)

# 加载指定状态类型下的所有 BOOK 卡片
func _load_books_for_status(status_type: int, target_grid: GridContainer) -> void:
	# 清空旧内容（避免重复加载）
	for child in target_grid.get_children():
		child.queue_free()

	# 临时切换状态
	var original_status = StatusManager.current_status
	StatusManager.current_status = status_type

	# 获取该分类下的所有文件名
	var file_names: Array[String] = FileStream.list_all_files()

	# 恢复原始状态
	StatusManager.current_status = original_status

	# 为每个文件名创建 BOOK 实例
	for name in file_names:
		var book_instance = BOOK.instantiate()
		book_instance.title = name  # 假设 BOOK 场景有一个 title 导出变量
		target_grid.add_child(book_instance)
	
	var add_something = ADD_SOMTHING.instantiate()
	add_something.status = status_type
	target_grid.add_child(add_something)
