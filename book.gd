extends Control

@export var title: String = "无标题"
var file_name: String = ""

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var texture_button: TextureButton = $TextureButton

signal book_selected(file_name)

func _ready() -> void:
	rich_text_label.bbcode_enabled = true  # ✅ 启用 BBCode
	set_title(title)
	texture_button.pressed.connect(_on_texture_button_pressed)

func set_title(new_title: String) -> void:
	title = new_title
	if is_node_ready():
		rich_text_label.text = "[center][b]%s[/b][/center]" % title

func _on_texture_button_pressed() -> void:
	print("Book 被点击: ", title)
	emit_signal("book_selected", file_name if file_name else title)

func set_file_name(name: String) -> void:
	file_name = name
	set_title(name)
