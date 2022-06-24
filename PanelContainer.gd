extends PanelContainer

var target = null

func _ready() -> void:
	var __ = GAME.connect("element_selected", self, "_on_target_changed")


func _on_target_changed(el):
	target = el
	if !is_instance_valid(target):
		visible = false
		return
	
	visible = true
	
func _physics_process(_delta: float) -> void:
	if !is_instance_valid(target):
		return
	rect_position = get_global_mouse_position()
	if target.is_class("Star"):
		var temp_str = String(target.temp)
		if temp_str.length() > 3:
			var first = temp_str.substr(0, (temp_str.length()-1) % 3+1)
			var temp_com = (temp_str.length()-1) / 3
			temp_str = temp_str.substr((temp_str.length()-1) % 3+1, temp_str.length()+1)
			for i in range(0,temp_com):
				temp_str=temp_str.insert(i * 3+i, ",")
			temp_str = first + temp_str
		$Label.text = "Temperature : " + temp_str + " K\n"
	else:
		$Label.text = ""
	$Label.text += "Mass : " + String(target.mass) + " masse solaire"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
