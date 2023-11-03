extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(".").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text_display("hi")


func text_display(in_text:String):
	get_node(".").visible = true
	get_node("text label").text = in_text
