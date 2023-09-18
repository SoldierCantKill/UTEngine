# Soldier Engine's Documentation

## Intro

This engine is made in Godot, as such, you'll need to download the Godot 4.1.1 Engine [here](https://github.com/godotengine/godot/releases/download/4.1.1-stable/Godot_v4.1.1-stable_win64.exe.zip) <br />

Godot is a reletively simple engine, it uses it's own language called GDScript (Godot team's own take on python). ~~THIS IS NOT PYTHON, IT IS A TAKE ON PYTHON. AS SUCH, SOME OBSCURE THINGS MIGHT BE DIFFERENT.~~ <br />

This documentation will be to the point, I expect you to have some coding experience, I am simply explaining the workflow of my engine. <br />

Credit where credit it due, my engine is heavily inspired by Scarm's Godot Undertale Engine and TML's GameMaker Undertale Engine. As such, if you have worked on any projects with that, this should be reletively simple to understand. <br />

This Engine was created with the intent of not needing to modify anything to be able to use it to your liking, as such, there is a bunch of stuff implemented in the engine that you will probably never use.<br /><br />

I recommend duplicating scenes if you are planning on making a new scene or battle. This makes the workflow much easier.<br /><br />

You should also take a look at the example scenes to see how I implemented the scenes. This can be very useful to you.<br /><br />

## Autoloads
The most important thing about this engine is it's use of autoloads:
```
audio.gd # Manages all the audio in the game
functions.gd # Global function caller
setting.gd # Manages things like the border, fullscreen, saving, etc.
ut_items.gd # Add all items here. This is where they are instantiated.
vars.gd # All important variables inside of the scene, such as the attack manager, or the player.
```
<br />

## Display Manager
This is where you change scenes, enter a different room, use the fadeins, or even show and hide the border. <br /><br />

This script has a variable called starting_scene that is used to enter a scene at the beginning of the game. <br /><br />

The game runs through 2 subviewports. One for the game and One for the border. <br /><br />

## Overworld

The Overworld engine is actually more simple than the battle engine. So I'll start with that. <br />

![image](https://github.com/SoldierCantKill/UTEngine/assets/75461200/5d633519-ada4-494a-aa78-1c818ae7d51f)
<br /><br />

### The Actual Scene

The most important thing in this scene is that it holds a static variable called rooms that holds all the rooms in the game, you need this put any new rooms in this variable. <br /><br />

The overworld scene is constructed mainly from the overworld script. <br /><br />

Stuff like the player construction, the room size, and some other things are stored here. <br /><br />

I recommend giving it a full in depth look on your own to see how this script works. <br /><br />

### Interactions

Interactions in this engine are handled by the Interactable class. When the player interacts with them, the function event() inside in interactable class will emit.

Take a look at this code that is inside the flower interact inside room 0:

```
func event():
  super.event()
  vars.main_writer.writer_text = "(sound:mono1)* The flowers...(pc)"
```

Don't worry too much about the writer's specific parsing for now, this will be explained later.

The setter for writer_text calls a function that parses this text. This will also call some signals that the character by default uses to disable it's input when the writer is talking.

This is all that really matters for interactable classes. <br /><br />

### Character

Characters in this engine are simple to implement. But they have a bunch of features so I'm just going to gloss over highlights:<br />

• You create characters in code by calling `Character.new(SPRITE_FRAMES_PATH)`. <br />
• Has an interactable shape that automatically calls the event function inside of the Character. <br />
• Has x and y floats to control where the character is moving. <br />
• Has input_enabled and cutscene booleans to enable/disable movement when needed for the player. <br /><br />

There's really not much to talk about for the character, check the already existing sample rooms for examples on how you can use the characters. <br /><br />

### Inventory

There's really not much to talk about here aswell, there's no CELL option support by default. <br /><br />

### Room Changers

Not going to go over these much either as there's just four things you need to understand: <br />
There are four variables that are important when entering a room.
```
@export var changer := 0 #What changer this is
@export var to_room := 0 #What room you are going to
@export var to_changer := 0 #What changer you are going to
@export_enum("up","down","left","right") var animation_when_tp_here = "down" #What animation the player will play once you enter this room.
```
<br /><br />

### Save Points

You place these in the overworld. Just like the character, it has an interactable attached to it, that calls onto this save point and generates the overworld hud and etc. <br />
If you want it to display text, you'll need to override the `event()` function that save point has. <br />

## Battle

Was pretty simple to read through the overworld engine. The battle engine is also split up into multiple objects. <br />
![image](https://github.com/SoldierCantKill/UTEngine/assets/75461200/61f31527-fadb-4453-b671-893f7fd29232) <br />

### The Actual Scene 

This scene is no where near the importance of the overworld scene. It simply assigns a bunch of variables. <br /><br />

### Enemies

This node holds any enemies that the scene has, this makes it so the enemies are visible to the hud manager, which makes it so that you can actually attack and act with these enemies. <br /><br />

### Hud Manager

This is the most complex script in the entire engine.<br /><br />

This script manages the UI of the battle engine as such, it is where most of the code in the battle let alone the engine is stored.<br />
Luckily, it is condensed into alot of functions, this makes it easy to override and make changes.<br />
The only functions you'll probably change are:<br />
```
setup_hud()
fight()
check()
use()
mercy()
```
These names are exactly what the functions do. I recommend reading those functions specifically so you can have an understanding how the hud works. <br /><br />

### Battle Box

This is the rectangle box that the heart is inside of during an attack in Undertale.<br />
You can change it's position by calling it's functions.
```
set_box_size(target : Array, resize_speed : float = 500)
reset_box_size(resize_speed = 500) #For clarification, this resets it back to the hud size.
insta_box_size(target : Array)
```
That's all you need to change. Everything else is done in the process function.<br /><br />

### Battle Writer

This is just the global writer for the battle. More on how the writer works later. <br /><br />

### Player Heart
This is the player heart of the game. 
All you should ever really need to do here is change the `heart_mode`. <br /><br />

### Attack Manager

This is where all the code for attacks is. <br />
This script spawns attacks, spawns bullets. And all sorts of stuff such as black screens and throwing the heart. <br />
This is an extremely song script but one of the easiest to understand.<br /><br />

### Dialouge Manager

This is the script that manages the enemies talking. You can personally call this at any time, but by default this is called once the player has finished their attack/turn.

## Writer
This is writer is pretty complex but most of it doesn't need to be accessed, there are some useful functions you can use such as:
```
set_font(new_font : String, new_font_size : int)
get_font_size()
```
Other than these functions, you set writer_event to a string the writer should say, and it will parse this data. <br /><br />

Consider this text:
```
vars.main_writer.set_font("sans_ow",28)
vars.main_writer.event.connect(func(): audio.play_music("music/sans"))
vars.main_writer.writer_text = "(font:mono)(size:32)(sound:none)(disable:x)* Human. (delay:.5)You are a bad guy.(pc)(event)(sound:sans)(face:sans/normal)(enable:x)* just kidding.(pc)"
```

This text would do the following things:<br />

• Sets the font to mono, the font size to 32, the sound to none, and disables the keybind x. <br />
• Plays the text `"* Human." ` <br />
• Waits 0.5 seconds. <br />
• Plays the text `"You are a bad guy."` <br />
• Waits for Z to be pressed, then clears the writer (p for pause c for clear) <br />
• Calls the event signal inside the writer, and disconnects all signals attached to it, sets the sound to sans, sets the face to sans, reenables the keybind x. <br />
• Plays the text `"* just kidding."` <br />
• Waits for Z to be pressed, then clears the writer (p for pause c for clear) <br /><br />

For the writer, you have multiple parsing options. <br /><br />

For options you call without a second parameter:
```
pause
clear
pc
func_funcname
```
<br />

For options you call without a second parameter:
```
delay:time
speed:time
font:name
audio:audio_to_play
music:music_to_play
size:num
sound:name
bb:bbcode
func_funcname:[array of params]
enable:z or x
disable:z or x
```
<br /><br />

##
This is the end of the documentation.
