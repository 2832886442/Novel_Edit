extends TextEdit

@onready var delete_btn: Button = $DeleteBtn


func _ready():
	# 启用自动换行
	wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	
	# 连接文本变化信号
	text_changed.connect(_on_text_changed)
	
	delete_btn.pressed.connect(_self_delete)
	
	# 初始更新大小
	_update_min_height()

func _on_text_changed():
	_update_min_height()

func _update_min_height():
	# 获取总行数（考虑换行）
	var line_count = get_line_count()
	
	# 计算所需最小高度（根据行高）
	var font = get_theme_font("font")
	var font_size = get_theme_font_size("font_size")
	var line_height = font.get_height(font_size) + 4  # 加上一些间距
	
	# 设置最小高度
	self.size.y = line_height * line_count + 20  # 加上一些边距
	
	# 通知父容器重新布局
	if get_parent() is Container:
		get_parent().queue_sort()

func _self_delete():
	self.queue_free()
