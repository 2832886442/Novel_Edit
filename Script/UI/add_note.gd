extends Control

@onready var save_btn: Button = $HBoxContainer/Sidebar/SaveBtn
@onready var cancel_btn: Button = $HBoxContainer/Sidebar/CancelBtn
@onready var add_line_btn: Button = $HBoxContainer/ScrollContainer/VBoxContainer/AddLine

@onready var line_edit: LineEdit = $HBoxContainer/ScrollContainer/VBoxContainer/LineEdit

@onready var v_box_container: VBoxContainer = $HBoxContainer/ScrollContainer/VBoxContainer


const ADD_LINE = preload("res://Scene/UI/model/add_line.tscn")

func _ready() -> void:
	save_btn.pressed.connect(save_btn_press)
	cancel_btn.pressed.connect(cancel_btn_press)
	add_line_btn.pressed.connect(add_line_btn_press)

func _process(delta: float) -> void:
	pass

func save_btn_press():
	var title = "# " + line_edit.text + "\n"
	var content:String = ""
	for node in v_box_container.get_children():
		if node.is_in_group("Outline"):
			content += "## " + node.text +"\n"
	print(content)
	FileStream.save_file(line_edit.text,title + content)

func cancel_btn_press():
	print("取消")

func add_line_btn_press():
	var addline = ADD_LINE.instantiate()
	var lastline = v_box_container.get_child(v_box_container.get_child_count() - 2)
	print(lastline)
	print(lastline.size)
	lastline.add_sibling(addline)
