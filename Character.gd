extends Resource
class_name Character

@export var title : String
@export var icon : Texture2D
@export var texture : Texture2D
@export var agility : int:
	set(value):
		agility = value
		speed = 200.0 / (log(agility) + 2) -25
		queue_reset()

var speed : float
var queue : Array[float]
var status = 1
var node

func queue_reset():
	queue.clear()
	for i in range(4):
		if queue.size() == 0:
			queue.append(speed * status)
		else:
			queue.append(queue[-1] + speed * status)
