extends RichTextLabel
class_name writer

var fonts = {
	"Mono" : "res://assets/fonts/main_mono.ttf",
	"Sans" : "res://assets/fonts/sans.ttf",
	"DT_Sans" : "res://assets/fonts/main.ttf",
	}

var sounds = {
	"None" : [""],
	"Mono1" : ["Characters/SND_TXT1"],
	"Mono2" : ["Characters/SND_TXT2"],
	"Sans" : ["Characters/sans"]
	}

var text_array : Array = []
var array_index : int = 0
var current_text : String = ""
var unfiltered_text : String = "="
var index : int = 0
var speed : float = 0.033333
var timer : float = 0
var is_typing : bool = true

func _ready():
	new_text(["/(font=Sans)yyyyyyyyyyyyyyyyyyyyyyy/(speed=2)[font=res://assets/fonts/sans.ttf][color=red]ddddddddddddddddd"])

func new_text(text : Array):
	text_array = text
	array_index = 0
	next()
	
signal func_done

func next():
	unfiltered_text = text_array[array_index]
	current_text = unfiltered_text
	
	var x = func():
		var start = current_text.findn("/(")
		var finish = current_text.findn(")") - start + 1
		print("FINISH ", start," ",finish)
		var remove : String = current_text.substr(start, finish)
		print("REMOVED ",remove)
		current_text = current_text.replace(remove,"")
		print("NEW ",current_text)
		func_done.emit()
	while(true):
		if(current_text.findn("/(") != -1 || current_text.findn(")") != -1):
			x.call()
			await func_done
		
		else:
			print("DONE")
			break
	text = current_text
	print(text)
	is_typing = true

func type():
	var filtered_text_block = RichTextLabel.new()
	filtered_text_block.text = unfiltered_text
	filtered_text_block.bbcode_enabled = true
	var filtered_text = filtered_text_block.get_parsed_text()
	#print(filtered_text)
	if(filtered_text[index] == "/" && index < filtered_text.length() - 1):
		if(filtered_text[index + 1] == "("):
			var right : int = filtered_text.findn(")",index)
			var parameter : String = filtered_text.substr(index,right - index + 1)
			if(parameter.contains("speed")):
				index += 1
				#print(int(parameter.substr(6)))
				speed = int(parameter.substr(6))
				return
				return
				
	visible_characters += 1
	index += 1


func _process(delta):
	if(is_typing):
		timer += delta
		#print(timer)
		if(timer >= speed):
			timer = 0
			type()
			if(index == unfiltered_text.length()):
				is_typing = false
