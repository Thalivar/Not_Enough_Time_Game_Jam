extends Resource
class_name Character

# Exported properties
@export var title : String          # Character's name/identifier
@export var icon : Texture2D       # Small icon for UI (e.g., timeline)
@export var texture : Texture2D    # Main sprite texture

# Agility stat (modifies speed and resets queue when changed)
@export var agility : int:
	set(value):
		agility = value
		# Calculate speed using logarithmic scaling (higher agility = faster)
		speed = 200.0 / (log(agility) + 2) - 25
		queue_reset()  # Reset action queue when agility changes

# Internal properties
var speed : float                  # Movement speed (derived from agility)
var queue : Array[float]          # Action queue (stores time values for turns)
var status = 1                    # Status multiplier (e.g., 1 = normal, 0.5 = slowed)
var node                          # Reference to the character's scene node

# Resets/initializes the action queue with time values
func queue_reset():
	queue.clear()  # Clear existing queue
	
	# Generate 4 time entries for the queue
	for i in range(4):
		if queue.size() == 0:
			# First entry: base speed × status (e.g., 100 × 1)
			queue.append(speed * status)
		else:
			# Subsequent entries: previous time + (speed × status)
			queue.append(queue[-1] + speed * status)

# Moves the character smoothly using a tween
func tween_movement(shift, tree):
	var tween = tree.create_tween()
	tween.tween_property(node, "position", node.position + shift, 0.2)
	await tween.finished  # Pause until movement completes

# Handles attack animation (moves forward briefly)
func attack(tree):
	var shift = Vector2(30, 0)  # Default attack dash distance
	
	# Reverse direction if character is on the left side of the screen
	if node.position.x < node.get_viewport_rect().size.x / 2:
		shift = -shift
	
	# Perform attack movement: dash forward, then return
	await tween_movement(-shift, tree)  # Dash toward enemy
	await tween_movement(shift, tree)    # Return to original position
	
	EventBus.next_attack.emit()  # Notify system to proceed to next attack

# Remove oldest queue entry and add a new future turn
func pop_out():
	queue.pop_front()
	queue.append(queue[-1] + speed * status)
